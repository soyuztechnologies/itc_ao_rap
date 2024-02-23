*&---------------------------------------------------------------------*
*& Report zdp_cust_maintain
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zdp_cust_maintain.

DATA : ls_cust type zdp_cust.

ls_cust-usrid = sy-uname.
ls_cust-max_open_days = 431.
ls_cust-max_gross_amount = 1600000 .
ls_cust-currency_code = 'EUR'.

modify zdp_cust
from ls_cust.
