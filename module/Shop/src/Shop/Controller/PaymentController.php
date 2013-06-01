<?php
namespace Shop\Controller;

class PaymentController extends \Zend\Mvc\Controller\AbstractActionController {
    
    public function payAction() {
//        $this->getRequest()->setContent('{"iscollapsed":false,"customer":{"name":"name","surname":"surname","company":"company","dob":"2012-05-27T23:00:00.000Z","add1":"aadd1","add2":"add2","town":"town","postcode":"postcode","country":"country","phone":"045444556","card":{"name":"cardname","number":"cardnumber","expire":"expire","issue":"issue"}},"dateoptions":{"changeYear":true,"changeMonth":true,"yearRange":"1900:-0","showOn":"button","buttonImage":"css/images/calendar.gif","buttonImageOnly":true,"dateFormat":"dd/mm/yy","showAnim":"clip"},"basket":{"id":13,"total":850,"products":[{"bl_id":14,"bl_basket":13,"bl_product":4,"bl_quantity":"15","p_ref":"ddr38gb","p_description":"Corsair DDR3 8Gb","p_long_description":"Corsair DDR3 8Gb","p_image_path":"http://siteipyme/img/MY-321-CS_200.jpg","p_category":18,"p_price":"50.000","c_name":null,"total":750},{"bl_id":15,"bl_basket":13,"bl_product":1,"bl_quantity":"1","p_ref":"i7","p_description":"i7","p_long_description":"i7","p_image_path":"http://siteipyme/img/CP-408-IN_60.jpg","p_category":14,"p_price":"100.000","c_name":null,"total":100}],"initialized":true}}');
//        $this->getRequest()->getHeaders()->addHeaderLine('X_REQUESTED_WITH','XMLHttpRequest');
//        
        
        if ($this->getRequest()->isXmlHttpRequest()) {
            $sJSONDataRequest = $this->getRequest()->getContent();
            $aRequest = (array)json_decode($sJSONDataRequest, true);
            
            $oDataFunctionGateway = $this->serviceLocator->get('Datainterface\Model\DataFunctionGateway');
            
            $aFunctionParams = array(':p_u_session'     => session_id()
                                    ,':p_b_id'          => $aRequest['basket']['id']
                                    ,':cust_name'       => $aRequest['customer']['name']
                                    ,':cust_surname'	=> $aRequest['customer']['surname']
                                    ,':cust_add1' 	=> $aRequest['customer']['add1']
                                    ,':cust_add2' 	=> $aRequest['customer']['add2']
                                    ,':cust_company'	=> $aRequest['customer']['company']
                                    ,':cust_country' 	=> $aRequest['customer']['country']	
                                    ,':cust_dob' 	=> $aRequest['customer']['dob']
                                    ,':cust_phone' 	=> $aRequest['customer']['phone']
                                    ,':cust_postcode' 	=> $aRequest['customer']['postcode']
                                    ,':cust_town'	=> $aRequest['customer']['town']
                                    ,':cust_card_expire'=> $aRequest['customer']['card']['expire']
                                    ,':cust_card_issue' => $aRequest['customer']['card']['issue']
                                    ,':cust_card_name'  => $aRequest['customer']['card']['name']
                                    ,':cust_card_number'=> $aRequest['customer']['card']['number']);
//            var_dump($aFunctionParams);
            $oResultSet = $oDataFunctionGateway->getDataRecordSet(
                'IPYME_FINAL'
                , 'payment_confirm'
                , $aFunctionParams);
        }
        
        $aResponse = $aRequest;
        $aResponse = array('success' =>1);
        
        return new \Zend\View\Model\JsonModel($aResponse);
    }
}
?>