<?php
namespace Shop\Controller;

class BasketController extends \Zend\Mvc\Controller\AbstractActionController {
    
    public function saveAction() {
//        $this->getRequest()->setContent('{"id":0,"total":730,"products":[{"id":1,"description":"INTEL I5 2500K","quantity":3,"price":"180.00","total":540,"currency":null},{"id":2,"description":"INTEL I5 3330","quantity":1,"price":"190.00","total":190,"currency":null}]}');
//        $this->getRequest()->getHeaders()->addHeaderLine('X_REQUESTED_WITH','XMLHttpRequest');
        
        $aBasketProductList = array();
        if ($this->getRequest()->isXmlHttpRequest()) {
            $sJSONDataRequest = $this->getRequest()->getContent();
            $aRequest = (array)json_decode($sJSONDataRequest, true);
            
            $oDataFunctionGateway = $this->serviceLocator->get('Datainterface\Model\DataFunctionGateway');
            $oUser = $this->getServiceLocator()->get('User\Model\UserCredentials')->getUserDetails();
            
            $aBasketProducts = array();
            foreach($aRequest['products'] as $aProduct){
                $aBasketProducts[] = $aProduct['quantity'].'~^~'.$aProduct['id'];
            }
            
            $aFunctionParameters = array(':p_user_id'          => $oUser->u_id
                                        , ':p_basket_products'  => implode('%^%', $aBasketProducts));
            
            $oResultSet = $oDataFunctionGateway->getDataRecordSet('IPYME_FINAL', 'save_basket_product_list', $aFunctionParameters);
            
            foreach($oResultSet as $aRow) {
                $aBasketProductList[] = $aRow;
            }
        }
            
        $aResponse = array('success' => 2, 'basket_list' => $aBasketProductList);
        return new \Zend\View\Model\JsonModel($aResponse);
    }
}
?>
