CLASS zcl_itc_ao_amdp DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_amdp_marker_hdb .
    CLASS-METHODS add_numbers IMPORTING VALUE(a) TYPE i VALUE(b) TYPE i
                              EXPORTING VALUE(res) TYPE i.
    CLASS-METHODS even_odd IMPORTING VALUE(a) TYPE i
                              EXPORTING VALUE(res) TYPE char4.
    CLASS-METHODS loop_process IMPORTING VALUE(a) TYPE i
                                EXPORTING VALUE(res) TYPE d.
    CLASS-METHODS read_customer_by_id IMPORTING value(i_bp_id) TYPE snwd_bpa-bp_id
                                      EXPORTING value(e_cust_name) TYPE snwd_bpa-company_name
                                      value(e_cust_role) TYPE snwd_bpa-bp_role.
    CLASS-METHODS calc_mrp_products EXPORTING
                                        VALUE(et_result) TYPE ZTT_ITC_PROD_MRP.
    CLASS-METHODS get_oia EXPORTING
                                VALUE(et_oia) type ZTT_OIA.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_itc_ao_amdp IMPLEMENTATION.
  METHOD add_numbers BY DATABASE PROCEDURE FOR HDB LANGUAGE SQLSCRIPT.
    /*We are creating a simple variable in SQL Script*/
    DECLARE tax integer;

    tax := 5;

    res := :a + :b + :tax;

  ENDMETHOD.
  METHOD even_odd BY DATABASE PROCEDURE FOR HDB LANGUAGE SQLSCRIPT.

    if( mod( :a,2 ) = 0) then
        res = 'Even';
    else
        res = 'Odd';
    END IF ;

  ENDMETHOD.
  METHOD loop_process BY DATABASE PROCEDURE FOR HDB LANGUAGE SQLSCRIPT.

    declare i integer;
    res = 0;
*    while :a > 0 do
*        res := :res + :a * 10;
*        a := :a - 1;
*    end WHILE;
    for i in 1..:a do
        res := :res + :i * 10;
    end for;

  ENDMETHOD.
  METHOD read_customer_by_id BY DATABASE PROCEDURE FOR HDB LANGUAGE SQLSCRIPT
  USING snwd_bpa.

     select company_name, bp_role into e_cust_name, e_cust_role
     from snwd_bpa where bp_id = i_bp_id;

  ENDMETHOD.
  METHOD calc_mrp_products BY DATABASE PROCEDURE FOR HDB LANGUAGE SQLSCRIPT
  USING snwd_pd snwd_texts.

    declare i, cnt integer;
    declare lv_gst, lv_mrp decimal( 10,2 );

    /*Step 1: Read the base product data joined with text data - implicit table*/
    lt_product = select head.product_id, head.category, head.price, head.currency_code as currency,
                        txt.text as name from snwd_pd as head inner join snwd_texts as txt
                        on head.name_guid = txt.parent_key and head.client = txt.client
                        where txt.language = 'E';

    /*Step 2: Count the number of records so you can do the Loop*/
    cnt := record_count( :lt_product );

*    loop at itab
    for i in 1..:cnt do
    /*Step 3: Access the Price component from table :table.COLUMN[index] */
        if( :lt_product.category[i] = 'Notebooks' ) then
            lv_gst := 1.18;
        elseif ( :lt_product.category[i] = 'Mice' ) then
            lv_gst := 1.12;
        else
            lv_gst := 1.08;
        end if;
    /*Step 4: Check product category and decide the GST rate*/
        lv_mrp = :lt_product.price[i] * :lv_gst;

    /*Step 5: DECLARElate the output table from selected data outtable.insert( ( col1, col2, col3 ), index ) */
        :et_result.insert( (
                               :lt_product.product_id[i],
                               :lt_product.name[i],
                               :lt_product.price[i],
                               round( :lv_mrp, 0 ),
                               :lt_product.currency[i],
                               :lt_product.category[i]
        ), i );

    end for;

  ENDMETHOD.

  METHOD get_oia BY DATABASE PROCEDURE FOR HDB LANGUAGE SQLSCRIPT
  USING snwd_bpa zdp_cust snwd_so_inv_head snwd_so_inv_item.

     declare lv_client, lv_curr_code varchar( 4 );
     declare lv_open_days integer;
     declare lv_open_amt decimal(10,2);
     declare lv_date date;

*    Step 1: Read the customizing table to know threshold, currency in which we need to convert
     select max_open_days, currency_code, max_gross_amount, current_date, session_context( 'CLIENT' )
            into lv_open_days, lv_curr_code, lv_open_amt, lv_date, lv_client from zdp_cust
            where usrid = ( select session_context( 'APPLICATIONUSER' ) from dummy );

*    Step 2: Read all the open invoices unpaid by customer with calculating open days
     lt_open_dats = select bp_id, company_name, days_between( to_date( head.changed_at ),
                                               now( ) ) as date_diff
            from snwd_bpa as bpa inner join snwd_so_inv_head as head
            on bpa.node_key = head.buyer_guid and bpa.client = head.client
            where head.payment_status = '';

     lt_final_days = select bp_id, company_name, avg( date_diff ) as open_days
                    from :lt_open_dats group by bp_id, company_name;

*    Step 3: Get the amount which is due (hetrogeneous currencies), convert to common currency
     lt_amount_unc = select bp_id, sum(itm.gross_amount) as gross_amount,
                                itm.currency_code from
                                snwd_so_inv_item as itm inner join snwd_so_inv_head as head
                                on itm.parent_key = head.node_key
                                inner join snwd_bpa as bpa
                                on head.buyer_guid = bpa.node_key
                                where head.payment_status = ''
                                group by bp_id, itm.currency_code
                                ;

    lt_amount = CE_CONVERSION( :lt_amount_unc, [
                                                    family = 'currency',
                                                    method = 'ERP',
                                                    source_unit_column = 'CURRENCY_CODE',
                                                    target_unit = :lv_curr_code,
                                                    reference_date = :lv_date,
                                                    output_unit_column = 'CURRENCY_CODE',
                                                    client = :lv_client
                                                ], [gross_amount] );

    lt_final_amount = select bp_id, sum( gross_amount ) as gross_amount, currency_code
                        from :lt_amount group by bp_id, currency_code;

    et_oia = select days.bp_id, company_name, open_days,
    amt.gross_amount as open_amount, amt.currency_code as currency_code,
    case
        when open_days > :lv_open_days and gross_amount > :lv_open_amt then 'X'
        else '' end
     as tagging from :lt_final_days as days inner join :lt_final_amount as amt
    on days.bp_id = amt.bp_id;

  ENDMETHOD.

ENDCLASS.
