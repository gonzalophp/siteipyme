<?php
namespace Datainterface\Model;

class MainMenu {
    function __construct() {
        
    }
    
    public function getMenu($aOptions){
        
        $aMenuList = array(
            (object) array(
                'label' => 'iPyME'
                , 'url' => '#/shop'
                , 'nodes' => array(
                    (object) array(
                        'label' => 'Purchase'
                        ,'icon' => 'icon_purchase'
                        , 'url' => '#/admin/purchase'
                        , 'nodes' => array(
                            (object) array(
                                'label' => 'Provider'
                                , 'url' => '#/admin/list/provider'
                                , 'nodes' => array())
                            , (object) array(
                                'label' => 'Order'
                                , 'url' => '#/admin/purchase/order'
                                , 'nodes' => array())))
                    , (object) array(
                        'label' => 'Sale'
                        , 'url' => '#/admin/sale'
                        ,'icon' => 'icon_sale'
                        , 'nodes' => array(
                            (object) array(
                                'label' => 'Customer'
                                , 'url' => '#/admin/list/customer'
                                , 'nodes' => array())
                            , (object) array(
                                'label' => 'Order'
                                , 'url' => '#/admin/sale/order'
                                , 'nodes' => array())))
                    , (object) array(
                        'label' => 'Product'
                        ,'icon' => 'icon_product'
                        , 'url' => ''
                        , 'nodes' => array())
                    , (object) array(
                        'label' => 'Delivery'
                        ,'icon' => 'icon_delivery'
                        , 'url' => '#/admin/sale/delivery'
                        , 'nodes' => array())
                    , (object) array(
                        'label' => 'Payment'
                        ,'icon' => 'icon_payment'
                        , 'url' => '#/admin/sale/payment'
                        , 'nodes' => array())
                    , (object) array(
                        'label' => 'Settings'
                        ,'icon' => 'icon_settings'
                        , 'url' => '#/admin/settings'
                        , 'nodes' => array(
                            (object) array(
                                'label' => 'Users'
                                , 'url' => '#/admin/list/user'
                                , 'nodes' => array())))))
            , );
        return $aMenuList;
    }
}
?>