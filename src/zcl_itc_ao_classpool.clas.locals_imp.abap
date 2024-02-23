*"* use this source file for the definition and implementation of
*"* local helper classes, interface definitions and type
*"* declarations
class zcl_earth DEFINITION.
    public section.
    methods leave_orbit EXPORTING value(r_value) type string.
ENDCLASS.
class zcl_earth IMPLEMENTATION.
    method leave_orbit.
        r_value = 'the settelite is leaving earth orbit'.
    ENDMETHOD.
endclass.

class zcl_planet1 DEFINITION.
    public section.
    methods enter_orbit EXPORTING value(r_value) type string.
    methods leave_orbit EXPORTING value(r_value) type string.
ENDCLASS.
class zcl_planet1 IMPLEMENTATION.
    method enter_orbit.
        r_value = 'the settelite is entering planet1 orbit'.
    ENDMETHOD.
    method leave_orbit.
        r_value = 'the settelite is leaving planet1 orbit'.
    ENDMETHOD.
endclass.

class zcl_mars DEFINITION.
    public section.
    methods enter_orbit EXPORTING value(r_value) type string.
    methods land EXPORTING value(r_value) type string.
ENDCLASS.
class zcl_mars IMPLEMENTATION.
    method enter_orbit.
        r_value = 'the settelite is entering MARS orbit'.
    ENDMETHOD.
    method land.
        r_value = 'the settelite is landing on MARS, we found water'.
    ENDMETHOD.
endclass.
