FUNCTION ZEBIZ_GETWEBFORMURLBYID.
*"--------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     VALUE(CUSTOMER_ID) TYPE  /ASU/CHAR72
*"     REFERENCE(E_PAYMENT_FORM) TYPE  ZEBIZ_CHARGEEBIZ_WEB_FORM
*"  EXPORTING
*"     REFERENCE(GET_EBIZ_WEB_FORM_URLRESULT) TYPE  STRING
*"--------------------------------------------------------------------
  DATA: EXC TYPE REF TO CX_ROOT.
  DATA: MSG TYPE STRING.
  DATA: PROXY_TEST TYPE REF TO ZEBIZ_CHARGECO_IE_BIZ_SERVICE,
        SECURITY   TYPE ZEBIZ_CHARGESECURITY_TOKEN.

  DATA: CWA        TYPE ZEBIZ_CONFIG
        .
  SELECT SINGLE * FROM ZEBIZ_CONFIG INTO CWA
    .

  TRY.
      DATA:
        INPUT          TYPE ZEBIZ_CHARGEIE_BIZ_SERVICE_G41,
        OUTPUT         TYPE ZEBIZ_CHARGEIE_BIZ_SERVICE_G40
       .
*     instantiate the object reference
      IF PROXY_TEST IS NOT BOUND.
        CREATE OBJECT PROXY_TEST
          EXPORTING
            LOGICAL_PORT_NAME = 'EBIZ'.
      ENDIF.
      SECURITY-SECURITY_ID = CWA-SECURITYKEY.

*

*     there is one input value for this service call for user id

      INPUT-SECURITY_TOKEN = SECURITY.
INPUT-E_PAYMENT_FORM = E_PAYMENT_FORM.
*     call the method (web service call) you can use the pattern to generate the code if you wish
      CALL METHOD PROXY_TEST->GET_EBIZ_WEB_FORM_URL
        EXPORTING
          INPUT  = INPUT
        IMPORTING
          OUTPUT = OUTPUT.

*     process the output

      GET_EBIZ_WEB_FORM_URLRESULT = OUTPUT-GET_EBIZ_WEB_FORM_URLRESULT.
    CATCH CX_AI_SYSTEM_FAULT INTO EXC.
      msg = exc->GET_TEXT( ).
       CONCATENATE 'Error in GET_CUSTOMER_PAYMENT_METHOD_P1 :' msg into msg.
          CALL FUNCTION 'ZEBIZ_LOGFILE'
  EXPORTING
    LOGTEXT = msg.
  .
      MESSAGE  W398(00) WITH MSG.
*CATCH zcx_zsqrt_exception.
    CATCH CX_AI_APPLICATION_FAULT INTO EXC.
      msg = exc->GET_TEXT( ).
       CONCATENATE 'Error in GET_CUSTOMER_PAYMENT_METHOD_P1 :' msg into msg.
          CALL FUNCTION 'ZEBIZ_LOGFILE'
  EXPORTING
    LOGTEXT = msg.
  .
      MESSAGE  W398(00) WITH MSG.
*      MESSAGE msg TYPE 'E'.
  ENDTRY.




ENDFUNCTION.
