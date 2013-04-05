<?php
namespace User\view\Helper;

class JSONResponseView extends \Zend\View\Model\ViewModel{
    public function __construct($variables = null, $options = null) {
        parent::__construct($variables, $options);
        $this->setTerminal(true);
        $this->setTemplate('xhr/xhr');
    }
    public function setArrayData($aData){
        $this->setVariable('XHR_Response', \Zend\Json\Json::encode($aData));
        return $this;
    }
}
?>