<?php
namespace Shop\Controller;

class ImageUploadController extends \Zend\Mvc\Controller\AbstractActionController {
    
    public function indexAction() {
        $aConfig = $this->getEvent()->getApplication()->getServiceManager()->get('config');
        $target_path = $_SERVER['DOCUMENT_ROOT'].'/img/'.basename( $_FILES['file']['name']);

        move_uploaded_file($_FILES['file']['tmp_name'], $target_path);
        $imagepath = $aConfig['image_path'].basename( $_FILES['file']['name']);
        $aResponse = array('imagepath' => $imagepath);
        return new \Zend\View\Model\JsonModel($aResponse);
    }
}
?>
