<?php
namespace Admin\Model;

class MainMenu {
    
    public $aMenuList;
    
    function __construct() {
        $this->aMenuList = array(
            (object) array(
                'label' => 'iPyME'
                ,'url' => ''
                ,'nodes' => array(
                    (object) array(
                        'label' => 'Purchase'
                        ,'url' => '#/admin/purchase'
                       ,'nodes' => array(
                            (object) array(
                                'label' => 'Provider'
                                ,'url' => '#/admin/purchase/provider'
                              , 'nodes' => array())
                          , (object) array(
                              'label' => 'Order'
                              ,'url' => '#/admin/purchase/order'
                              , 'nodes' => array())))
                   ,(object) array(
                       'label' => 'Sale'
                       ,'url' => '#/admin/sale'
                      ,'nodes' => array(
                            (object) array(
                                'label' => 'Customer'
                                ,'url' => '#/admin/sale/customer'
                              , 'nodes' => array())
                          , (object) array(
                              'label' => 'Order'
                              ,'url' => '#/admin/sale/order'
                              , 'nodes' => array())
                          , (object) array(
                              'label' => 'Delivery'
                              ,'url' => '#/admin/sale/delivery'
                              , 'nodes' => array())
                          , (object) array(
                              'label' => 'Payment'
                              ,'url' => '#/admin/sale/payment'
                              , 'nodes' => array())))
                    ,(object) array(
                        'label' => 'Product'
                        ,'url' => ''
                       ,'nodes' => array(
                           (object) array(
                                'label' => 'Stores'
                                ,'url' => '#/admin/stores'
                               ,'nodes' => array())
                           ,(object) array(
                                'label' => 'Catalog'
                                ,'url' => '#/admin/product/catalog'
                               ,'nodes' => array())
                           ,(object) array(
                                'label' => 'Category'
                                ,'url' => '#/admin/product/category'
                               ,'nodes' => array())
                           ,(object) array(
                                'label' => 'Item'
                                ,'url' => '#/admin/product/item'
                               ,'nodes' => array())))
                    ,(object) array(
                        'label' => 'Settings'
                        ,'url' => '#/admin/settings'
                       ,'nodes' => array(
                           (object) array(
                                'label' => 'Users'
                                ,'url' => '#/admin/user'
                               ,'nodes' => array())))))
            , (object) array(
                'label' => 'Sign In'
                ,'url' => '#/user/signin'
               ,'nodes' => array())
            , (object) array(
                'label' => 'Basket'
                ,'url' => '#/user/basket'
               ,'nodes' => array())
            , (object) array(
                'label' => 'Resources'
                ,'url' => 'http://www.elmundo.es'
               ,'nodes' => array(
                    (object) array(
                        'label' => 'Resources A'
                        ,'url' => 'http://www.elmundo.es'
                       ,'nodes' => array())
                    , (object) array(
                        'label' => 'Resources B'
                        ,'url' => '#/admin/product'
                       ,'nodes' => array(
                            (object) array(
                                'label' => 'Resources B A'
                                ,'url' => 'http://www.elmundo.es'
                               ,'nodes' => array())
                            , (object) array(
                                'label' => 'Product'
                                ,'url' => '#/admin/product'
                               ,'nodes' => array()))))));
    }
}
?>
