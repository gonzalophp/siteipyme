<?php
namespace Shop\Controller;

class BasketController extends \Zend\Mvc\Controller\AbstractActionController {
    
    public function getAction() {
        $this->getRequest()->setContent('{}');
        $this->getRequest()->getHeaders()->addHeaderLine('X_REQUESTED_WITH','XMLHttpRequest');
        
        
        $aBasketProductList = array();
        if ($this->getRequest()->isXmlHttpRequest()) {
            $sJSONDataRequest = $this->getRequest()->getContent();
            $aRequest = (array)json_decode($sJSONDataRequest, true);
            
            $oDataFunctionGateway = $this->serviceLocator->get('Datainterface\Model\DataFunctionGateway');
            $oUser = $this->getServiceLocator()->get('User\Model\UserCredentials')->getUserDetails();
            
            $oResultSet = $oDataFunctionGateway->getDataRecordSet('IPYME_FINAL'
                    , 'get_basket_product_list'
                    , array(':p_user_id'          => !is_null($oUser) ? $oUser['u_id']:null));
            
            foreach($oResultSet as $aRow) {
                $aRow['bl_quantity'] = number_format($aRow['bl_quantity'], 0);
                $aBasketProductList[] = $aRow;
            }
        }
        
        $aBasket = array('id' => (count($aBasketProductList) ? $aBasketProductList[0]['bl_basket']:0)
                        ,'products' => $aBasketProductList);
        
        $aResponse = array('success' => 1, 'basket' => $aBasket);
        return new \Zend\View\Model\JsonModel($aResponse);
    }
    
    
    public function saveAction() {
//        $this->getRequest()->setContent('{"id":7,"total":370,"products":[{"bl_id":7,"bl_basket":7,"bl_product":1,"bl_quantity":"1.000","p_ref":"INTEL I5 2500K","p_description":"INTEL I5 2500K","p_long_description":"Quad Core, 3.30GHz clock speed, 32nm Process, 6MB L3 Cache, Dual Channel DDR3 Controller, Integrated HD 3000 Graphics, 3 Year Warranty","p_image_path":"http://ipymeback/img/CP-360-IN_200.jpg","p_category":20,"p_price":"180.000","c_name":null,"total":180},{"bl_id":8,"bl_basket":7,"bl_product":2,"bl_quantity":"1.000","p_ref":"INTEL I5 3330","p_description":"INTEL I5 3330","p_long_description":"Quad Core Technology, 3.00GHz clock speed, 22nm Process, 6MB L3 Cache, Dual Channel DDR3 Controller, Integrated HD 2500 Graphics, 3 Year Warranty","p_image_path":"http://ipymeback/img/CP-360-IN_200.jpg","p_category":20,"p_price":"190.000","c_name":null,"total":190}],"initialized":true}');
//        $this->getRequest()->getHeaders()->addHeaderLine('X_REQUESTED_WITH','XMLHttpRequest');
        
        $aBasketProductList = array();
        $nBasketId = 0;
        if ($this->getRequest()->isXmlHttpRequest()) {
            $sJSONDataRequest = $this->getRequest()->getContent();
            $aRequest = (array)json_decode($sJSONDataRequest, true);
            
            $oDataFunctionGateway = $this->serviceLocator->get('Datainterface\Model\DataFunctionGateway');
            $oUser = $this->getServiceLocator()->get('User\Model\UserCredentials')->getUserDetails();
            
            $aBasketProducts = array();
            foreach($aRequest['products'] as $aProduct){
                $aBasketProducts[] = $aProduct['bl_quantity'].'~^~'.$aProduct['bl_product'];
            }
            
            $aFunctionParameters = array(':p_user_id'          => $oUser['u_id']
                                        , ':p_basket_products'  => implode('%^%', $aBasketProducts));
            $oResultSet = $oDataFunctionGateway->getDataRecordSet('IPYME_FINAL', 'save_basket_product_list', $aFunctionParameters);
            
            foreach($oResultSet as $aRow) {
                $aBasketProductList[] = $aRow;
            }
            
            $nBasketId = (count($aBasketProductList) ? $aBasketProductList[0]['bl_basket']:0);
        }
        
        $aBasket = array('id'       => $nBasketId
                        ,'products' => $aBasketProductList);
        
        $aResponse = array('success' => 1, 'basket' => $aBasket);
        return new \Zend\View\Model\JsonModel($aResponse);
    }
}
?>
