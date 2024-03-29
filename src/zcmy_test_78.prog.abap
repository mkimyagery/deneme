*&---------------------------------------------------------------------*
*& Report ZCM_TEST_78
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zcmy_test_78.

SELECTION-SCREEN BEGIN OF BLOCK a1 WITH FRAME TITLE TEXT-001 NO INTERVALS.

  PARAMETERS : p_carrid TYPE s_carr_id,
               p_inc1   RADIOBUTTON GROUP abc,
               p_exc1   RADIOBUTTON GROUP abc.

SELECTION-SCREEN END OF BLOCK a1.

SELECTION-SCREEN BEGIN OF BLOCK a2 WITH FRAME TITLE TEXT-002 NO INTERVALS.

  PARAMETERS : p_connid TYPE zcm_de_connid2 , "s_conn_id,
               p_inc2   RADIOBUTTON GROUP xyz,
               p_exc2   RADIOBUTTON GROUP xyz.

SELECTION-SCREEN END OF BLOCK a2.

TYPES : BEGIN OF gty_str_carrid,
          sign   TYPE c LENGTH 1,
          option TYPE c LENGTH 2,
          low    TYPE s_carr_id,
          high   TYPE s_carr_id,
        END OF gty_str_carrid.

TYPES : BEGIN OF gty_str_connid,
          sign   TYPE c LENGTH 1,
          option TYPE c LENGTH 2,
          low    TYPE s_conn_id,
          high   TYPE s_conn_id,
        END OF gty_str_connid.

DATA : gs_selopt_carrid TYPE gty_str_carrid,
       gs_selopt_connid TYPE gty_str_connid,
       gt_selopt_carrid TYPE RANGE OF s_carr_id,
       gt_selopt_connid TYPE RANGE OF s_conn_id,
       gt_sflight       TYPE TABLE OF sflight,
       gs_sflight       TYPE sflight,
       gv_no_lines      TYPE i.

START-OF-SELECTION.

  PERFORM check_parameters.
  PERFORM selopt_carrid.
  PERFORM selopt_connid.
  PERFORM select_data.
  PERFORM write_data.
*&---------------------------------------------------------------------*
*& Form check_parameters
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM check_parameters .
  IF p_carrid IS INITIAL AND p_connid IS INITIAL.
    MESSAGE TEXT-003 TYPE 'S' DISPLAY LIKE 'E'.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form selopt_carrid
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM selopt_carrid .

  IF p_carrid IS NOT INITIAL.
    IF p_inc1 IS NOT INITIAL.
      gs_selopt_carrid-sign = 'I'.
    ELSE.
      gs_selopt_carrid-sign = 'E'.
    ENDIF.

    gs_selopt_carrid-option = 'EQ'.
    gs_selopt_carrid-low    = p_carrid.
    APPEND gs_selopt_carrid TO gt_selopt_carrid.
    CLEAR: gs_selopt_carrid.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form selopt_connid
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM selopt_connid .

  IF p_connid IS NOT INITIAL.
    IF p_inc2 IS NOT INITIAL.
      gs_selopt_connid-sign = 'I'.
    ELSE.
      gs_selopt_connid-sign = 'E'.
    ENDIF.

    gs_selopt_connid-option = 'EQ'.
    gs_selopt_connid-low    = p_connid.
    APPEND gs_selopt_connid TO gt_selopt_connid.
    CLEAR: gs_selopt_connid.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form select_data
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM select_data .

  SELECT * FROM sflight
     INTO TABLE gt_sflight
          WHERE carrid IN gt_selopt_carrid
            AND connid IN gt_selopt_connid.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form write_data
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM write_data .

  IF gt_sflight IS NOT INITIAL.

    DESCRIBE TABLE gt_sflight LINES gv_no_lines.
    WRITE: TEXT-004,gv_no_lines.
    SKIP.
    ULINE.

    LOOP AT gt_sflight INTO gs_sflight.

      WRITE : / gs_sflight-carrid,
                gs_sflight-connid,
                gs_sflight-fldate,
                gs_sflight-price,
                gs_sflight-currency,
                gs_sflight-planetype,
                gs_sflight-seatsmax,
                gs_sflight-seatsocc,
                gs_sflight-paymentsum,
                gs_sflight-seatsmax_b,
                gs_sflight-seatsocc_b,
                gs_sflight-seatsmax_f,
                gs_sflight-seatsocc_f.
      CLEAR : gs_sflight.

    ENDLOOP.


  ELSE.

    WRITE : TEXT-005.

  ENDIF.

ENDFORM.
