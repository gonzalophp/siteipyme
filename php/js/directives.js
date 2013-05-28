'use strict';

/* Directives */

angular.module('iPymeApp.Menu') 
    .directive('mainMenu', function($http) {
        return { 
            restrict:'E',
            replace:true,
            scope:{menuitem:'='},
            templateUrl:'tpl/ng.main_menu.tpl',
        }
    })
    .directive('categorymenu', function($http) {
        return { 
            restrict:'E',
            replace:true,
            scope:{menuitem:'=', menutree:'=', menuclick:'=', getLiClass:'='},
            templateUrl:'tpl/ng.main_menu.tpl',
        }
    })
    .directive('menuclick',function(getParentByTagName){
        return {
            restrict:'A',
            link:function(scope,element,attr){
                if (scope.$parent.menuitem && scope.$parent.menuitem.url == ""){
                    element.bind('click', function(e){
                        scope.menuclick(scope.$parent.menuitem);
                        return false;
                    });
                }
                
                element.bind('click',function(){
                    if (attr.menuclick=='closemenu'){
                        var ul = getParentByTagName(this,'UL');
                        if (ul.parentNode.nodeName=='LI'){
                            ul.style.display="none";
                            setTimeout(function(){ul.style.display="";}, 300);
                        }
                    }
                });
            }
        }
    });
    
angular.module('iPymeApp')
    .directive('productTable',function(){
        return {
            restrict:'E',
            replace:true,
            template:'<p>product table template</p>'
        }
    })
    
    .directive('ipymeedit', function(){
        return {
            restrict:'E',  
            replace:true,
            template:'<div class="attribute"><button ng-click="removeItem()">x</button><p ng-hide="showinput">{{data.pca_attribute}}</p><input ng-show="showinput" type="text" ng-model="inputdata"/></div>',
            scope:{values:'=',
                   remove:'=', 
                   edited:'='
            },   
            link: function(scope,element,attr,ctrl){
                scope.inputdata = '';
                scope.input = element.find('input');
                if((scope.inputdata == '') && (scope.values[scope.$parent.$index].pca_attribute == '')) {
                    scope.showinput = true;
                    scope.input.editing = true;
                } 
                else {
                    scope.showinput = false;
                    scope.input.editing = false;
                }
                scope.data = {pca_attribute: scope.values[scope.$parent.$index].pca_attribute};
                element.bind('keydown', function(e) {
                    switch(e.which) {
                        case 27: // [esc] 
                            if (scope.inputdata == '') {
                                scope.removeItem();
                            }
                            scope.showinput = false;
                            scope.inputdata=scope.data.pca_attribute;
                        break;
                        case 13: // 
                            if (scope.inputdata == "") {
                                scope.removeItem();
                            }
                            else {
                                scope.data.pca_attribute = scope.inputdata;
                                scope.showinput = false;
                            }
                        break;
                    }
                    scope.$apply();
                });
                element.bind('dblclick', function(e) {
                    scope.inputdata = scope.values[scope.$parent.$index].pca_attribute;
                    scope.showinput = true;
                    scope.$apply();
                    scope.input.focus();
                    scope.input.editing = true;
                });
                scope.removeItem = function(){
                    scope.remove(scope.$parent.$index);
                }
                
                scope.input.bind('blur', function(e){ 
                    if(scope.input.editing){
                        scope.input.editing = false;
                        if (scope.inputdata == ''){
                             scope.removeItem();
                        }
                        else {
                            scope.values[scope.$parent.$index].pca_attribute = scope.inputdata;
                            scope.edited();
                        }
                        scope.showinput = false;
                        scope.$root.$$phase || scope.$root.$apply();
                    }
                    
                }); 
                
                scope.input.focus();
            }
        }
    })
.directive('relatedattribute', function(){
    return {
        restrict:'E',
        template:'<li ng-class="{true:\'selected\', false:\'\'}[modelattribute.selected==1]">{{modelattribute.value}}</li>',
        scope:{modelattribute:'=modelattribute', click:'=ngClick'},
        link:function(scope, element, attr){
            element.bind('click', function(){
                scope.click(scope.modelattribute);
                return false;
            });
        }
    }
})    
.directive('imageupload', function(){
    return {
        restrict:'E',
        template:'<form enctype="multipart/form-data"><input style="position:absolute;top:-999em;" name="file" type="file"/><div style="border:solid 1px red;width:100px; height:100px;"><img ng-show="imagepath" ng-src="{{imagepath}}"/></div></form>',
        scope:{imagepath:'=ngModel',imagechange:'='},
        link:function(scope, element, attr){
            element.find('input').bind('change', function(e){
                e.target.files.length && scope.imagechange(new FormData(element.find('form')[0]));
            });
            element.find('div').bind('click', function(e){
               element.find('input').trigger('click');
            });
        }
    }
})
.directive('quantity', function(){
    return {
        restrict:'E',
        scope:{value:'=ngModel'},
        replace:true,
        template:'<div><button class="minus" ng-click="minus()">-</button><input type="text" ng-model="value"/><button class="more" ng-click="more()">+</button></div>',
        link:function(scope, element, attr) {
            scope.minus = function(){
                (scope.value>1) && scope.value--;
            }
            
            scope.more = function() {
                scope.value++;
            }
        }
    }
})
.directive('displayproduct', function(){
    return {
        restrict:'E',
        scope:{product:'=ngModel', addbutton:'=ngAddbutton'},
        replace:true,
        template:'<table><tbody><tr><td rowspan="3"><a href="#/shop/product/{{product.id}}"><img ng-src="{{product.image_path}}" alt="{{product.longDescription}}"/></a></td><td><a href="#/shop/product/{{product.id}}"><span>{{product.description}}</span></a></td></tr><tr><td><span>{{product.currency}}</span>&nbsp;<span>{{product.price}}</span></td></tr><tr><td><button class="shop addtobasket" ng-click="addbutton(product)">Add</button><quantity class="basketquantity" ng-model="product.quantity"></quantity></td></tr></tbody></table>',
        link:function(scope, element, attr) {
        }
    }
})
.directive('basketproduct', function(){
    return {
        restrict:'E',
        scope:{product:'=ngModel'},
        replace:true,
        template:'<table><tbody><tr><td><quantity class="basketquantity" ng-model="product.bl_quantity"></quantity></td><td><span>{{product.p_description}}</span></td><td><span>{{product.c_name}}</span>&nbsp;<span>{{product.total}}</span></td><td><button class="ipymebuttonclose" ng-click="removebutton(product)">x</button></td></tr></tbody></table>',
        link:function(scope, element, attr) {
            scope.removebutton = function() {
                 scope.$parent.$parent.basket.products.splice(scope.$parent.$index,1);
            }
            
            scope.$watch('product.bl_quantity', function(quantity){
                scope.product.total = scope.product.p_price*quantity;
            });
        }
    }
})
.directive('basket', function($window,$location){
    return {
        restrict:'E',
        scope:{basket:'=ngModel', persist:'='},
        replace:true,
        template:'<div><p class="ipymeTitle">Basket</p><div class="productlist"><ul><li ng-repeat="basketproduct in basket.products"><basketproduct ng-model="basketproduct" ></basketproduct></li></ul></div><p class="baskettotal">Total: {{basket.total}}</p><button class="shop checkout" ng-click="checkout()">Checkout</button></div>',
        link:function(scope, element, attr) {
            scope.basket = {id:0
                            ,total:0
                            ,products:[]
                            ,initialized:false}
                            
            scope.countDownToPersist = function() {
                clearTimeout(scope.timeOutToPersist);
                scope.timeOutToPersist = setTimeout(scope.persist, 2000);
            }
            
            scope.checkout = function() {
                scope.persist(false);
                $location.path( "/basket" );
            }
            
            var windowNode = angular.element($window)
                ,innerHeight = 0
                ,resize = function() {
                    innerHeight = 0;
                    var p = element.children('p');
                    for(var i=0;i<p.length;i++) innerHeight += p[i].offsetHeight;
                    element.children('div.productlist').css('maxHeight', (windowNode.height()-40-innerHeight)+'px');
                    element.css('maxHeight', (windowNode.height())+'px');
                }
                ,scroll = function() {
                    var windowTop = windowNode.scrollTop()
                    , tdBasketTop = $('td.basket').offset().top
                    , floatingTop = (windowTop > tdBasketTop) ? windowTop - tdBasketTop : 0;

                    if (floatingTop+(parseInt(element.css('height')))+20 < parseInt(element.parents('div.ipymeshopcolumns').css('height'))){
                        element.stop().animate({"marginTop": floatingTop + "px"}, "slow" );	
                    }
                }
                ,basketchange = function(){
                    var total=0, p = scope.basket.products;
                    for(var i in p) total += p[i].total;
                    scope.basket.total = total;
                    if (scope.basket.initialized) scope.countDownToPersist();
                }
                ,initialize = function() {
                    scope.persist(true);
                }
                
            windowNode.bind('resize', resize);
            windowNode.bind('scroll', scroll);
            scope.$on("$destroy", function() {windowNode.unbind('scroll');windowNode.unbind('resize');});
            scope.$watch('basket.products', basketchange, true);
            
            resize();
            initialize();
        }
    }
})

.directive('basketsummary', function($window,$location){
    return {
        restrict:'E',
        scope:{basket:'=ngModel', persist:'='},
        replace:true,
        template:'<div>\
                    <p class="ipymeTitle">Basket</p>\
                    <div class="productlist">\
                        <ul>\
                            <li ng-repeat="basketproduct in basket.products"><basketproduct ng-model="basketproduct" ></basketproduct></li>\
                        </ul>\
                    </div>\
                        <p class="baskettotal">Total: {{basket.total}}</p>\
                        <div class="ipymeButtonsGroup">\n\
                            <button class="shop" ng-click="redirect(\'/shop\')">Continue Shopping</button>\
                            <button class="shop" ng-click="redirect(\'/payment\')">Proceed to Payment</button>\
                        </div>\
                </div>',
        link:function(scope, element, attr) {
            scope.basket = {id:0
                            ,total:0
                            ,products:[]
                            ,initialized:false}
                            
            scope.countDownToPersist = function() {
                clearTimeout(scope.timeOutToPersist);
                scope.timeOutToPersist = setTimeout(scope.persist, 2000);
            }
            
            scope.redirect = function(path) {
                scope.persist(false);
                $location.path(path);
            }
            
            var windowNode = angular.element($window)
                ,innerHeight = 0
                
                ,basketchange = function(){
                    var total=0, p = scope.basket.products;
                    for(var i in p) total += p[i].total;
                    scope.basket.total = total;
                    if (scope.basket.initialized) scope.countDownToPersist();
                }
                ,initialize = function() {
                    scope.persist(true);
                }
                
            scope.$on("$destroy", function() {windowNode.unbind('scroll');windowNode.unbind('resize');});
            scope.$watch('basket.products', basketchange, true);
            
            initialize();
        }
    }
})


                                
                                

    
;