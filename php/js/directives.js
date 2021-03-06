'use strict';

/* Directives */

angular.module('iPymeApp.Menu') 
    .directive('mainMenu', function() {
        return { 
            restrict:'E',
            replace:true,
            scope:{menuitem:'=', menutree:'=', menuclick:'='},
            templateUrl:'tpl/ng.main_menu.tpl',
        }
    })
    .directive('menuclick',function(getParentByTagName){
        return {
            restrict:'A',
            link:function(scope,element,attr){
                if (scope.$parent.menuitem && scope.$parent.menuitem.url == ""){
                    element.bind('click', function(e){
                        scope.menuclick && scope.menuclick(scope.$parent.menuitem);
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
.directive('imageupload', function(imageSourceHost){
    return {
        restrict:'E',
        template:'<form enctype="multipart/form-data"><input style="position:absolute;top:-999em;" name="file" type="file"/><div class="image_preview"><img ng-show="imagepath" ng-src="{{imageSourceHost}}{{imagepath}}"/></div></form>',
        scope:{imagepath:'=ngModel',imagechange:'='},
        link:function(scope, element, attr){
            scope.imageSourceHost =  imageSourceHost;
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
        template:'<div class="quantity">\
                    <table>\
                        <tbody>\
                            <tr>\
                                <td><button class="minus" ng-click="minus()">-</button></td>\
                                <td><input type="text" ng-model="value"/></td>\
                                <td><button class="more" ng-click="more()">+</button></td>\
                            </tr>\
                        </tbody>\
                    </table>\
                </div>',
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
.directive('displayproduct', function(imageSourceHost){
    return {
        restrict:'E',
        scope:{product:'=ngModel', addbutton:'=ngAddbutton'},
        replace:true,
        template:'<table><tbody><tr><td rowspan="3"><a href="#/shop/product/{{product.id}}"><img ng-src="{{imageSourceHost}}{{product.image_path}}" alt="{{product.longDescription}}"/></a></td><td><a href="#/shop/product/{{product.id}}"><span>{{product.description}}</span></a></td></tr><tr><td><span>{{product.longDescription}}</span></td><td><span>{{product.currency}}</span>&nbsp;<span>{{product.price}}</span></td></tr><tr><td colspan="2"><button class="shop addtobasket" ng-click="addbutton(product)">Add</button><quantity class="basketquantity" ng-model="product.quantity"></quantity></td></tr></tbody></table>',
        link:function(scope, element, attr) {
            scope.imageSourceHost=imageSourceHost;
        }
    }
})
.directive('basketproduct', function(){
    return {
        restrict:'E',
        scope:{product:'=ngModel', basket:'=ngBasket'},
        replace:true,
        template:'<table><tbody><tr><td><quantity class="basketquantity" ng-model="product.bl_quantity"></quantity></td><td><a href="#/shop/product/{{product.bl_product}}"><span>{{product.p_description}}</span></a></td><td><span>{{product.c_name}}</span>&nbsp;<span>{{product.total}}</span></td><td><button class="ipymebuttonclose" ng-click="removebutton(product)">x</button></td></tr></tbody></table>',
        link:function(scope, element, attr) {
            scope.removebutton = function() {
                scope.basket.products.splice(scope.$parent.$index,1);
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
        template:'<div><div ng-show="persist.basketWaitingUpdate" class="ajax-waiting"></div><p class="ipymeTitle">Basket</p><div class="productlist"><ul><li ng-repeat="basketproduct in basket.products"><basketproduct ng-basket="basket" ng-model="basketproduct" ></basketproduct></li></ul></div><p class="baskettotal">Total: {{basket.total}}</p><button class="shop checkout" ng-click="checkout()">Checkout</button></div>',
        link:function(scope, element, attr) {
            scope.basket = {id:0
                            ,total:0
                            ,products:[]
                            ,initialized:false}
                            
            scope.countDownToPersist = function() {
                clearTimeout(scope.timeOutToPersist);
                scope.timeOutToPersist = setTimeout(scope.persistTimeOut, 2000);
            }
            
            scope.persistTimeOut = function(){
                scope.persist(false);
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
                    , floatingTop = (windowTop > tdBasketTop) ? windowTop - tdBasketTop-10 : 0;

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
            scope.$on("$destroy", function() {scope.persist(false);windowNode.unbind('scroll');windowNode.unbind('resize');});
            scope.$watch('basket.products', basketchange, true);
            
            resize();
            initialize();
        }
    }
})
.directive('basketsummary', function($window,$location){
    return {
        restrict:'E',
        scope:{model:'=ngModel', persist:'='},
        replace:true,
        template:'<div>\
                    <p class="ipymeTitle">Basket</p>\
                    <div class="productlist">\
                        <ul>\
                            <li ng-repeat="basketproduct in model.basket.products"><basketproduct ng-basket="model.basket" ng-model="basketproduct" ></basketproduct></li>\
                        </ul>\
                    </div>\
                        <p class="baskettotal">Total: {{model.basket.total}}</p>\
                        <div class="ipymeButtonsGroup">\n\
                            <button class="shop backtoshop" ng-click="redirect(\'/shop\')">Continue Shopping</button>\
                            <button class=" proceedtopay" ng-click="pay()"><img src="https://www.paypal.com/en_US/i/btn/btn_xpressCheckout.gif" align="left" style="margin-right:7px;"></button>\
                        </div>\
                </div>',
        link:function(scope, element, attr) {
            scope.model.basket = {id:0
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
            
            scope.pay = function(){
                simpleCart.empty();
                
                simpleCart({
                    checkout: { 
                        type: "PayPal" , 
                        email: "ipymesoft-uk@gmail.com" ,

                        // use paypal sandbox, default is false
                        sandbox: true , 

                        // http method for form, "POST" or "GET", default is "POST"
                        method: "GET" , 

                        // url to return to on successful checkout, default is null
                        success: 'http://ipyme.uk.to/' , 
                        currency: "GBP",
                        // url to return to on cancelled checkout, default is null
                        cancel: $location.absUrl()
                        ,
                       
                    } 
                });
                


                simpleCart.currency({
                  code: "GBP" ,
                  symbol: "£" ,
                  name: "UK Pound"
                });
                
                for(var i=0;i<scope.model.basket.products.length;i++){
                    
                    console.log(scope.model.basket.products[i]);
                    
                    simpleCart.add({ 
                        name: scope.model.basket.products[i].p_ref ,
                        price: scope.model.basket.products[i].p_price ,
                        size: scope.model.basket.products[i].p_ref ,
                        quantity: scope.model.basket.products[i].bl_quantity
                    });

                    
//                    $$hashKey: "00B"
//                    bl_basket: 18
//                    bl_id: 19
//                    bl_product: 2
//                    bl_quantity: "4"
//                    c_name: "GBP"
//                    p_category: 8
//                    p_description: "Intel Core i5-4670K 3.40GHz"
//                    p_image_path: "/CP-472-IN_200.jpg"
//                    p_long_description: "Intel Core i5-4670K 3.40GHz (Haswell) Socket LGA1150 Processor - OEM with FREE Grid 2 PC Game Intel's latest 4th gen CPU, offering better performance, lower power consumption, improved memory overclocking and comes with GRID 2 PC Game FREE!!"
//                    p_price: "180.000"
//                    p_ref: "Intel Core i5-4670K 3.40GHz"
//                    total: 720

                }
                
                simpleCart.checkout();
            }
            
            var windowNode = angular.element($window)
                ,basketchange = function(){
                    var total=0, p = scope.model.basket.products;
                    for(var i in p) total += p[i].total;
                    scope.model.basket.total = total;
                    if (scope.model.basket.initialized) scope.countDownToPersist();
                }
                ,initialize = function() {
                    scope.persist(true);
                }
                
            scope.$on("$destroy", function() {scope.persist(false);windowNode.unbind('scroll');windowNode.unbind('resize');});
            scope.$watch('model.basket.products', basketchange, true);
            
            initialize();
        }
    }
})
.directive('shoptopbar', function(ipymeajax,$window,$location, $rootScope){
    return {
        restrict:'E',
        scope:{},
        replace:true,
        template:'<div ng-show="user.initialized==1" class="ipymeshoptopbar">\
                    <ul>\
                        <li ng-click="shopmain()" class="shopmain"><span>iPyME</span></li>\
                        <li ng-show="user.name" ng-click="logout()" class="logout"><span>logout</span></li>\
                        <li ng-click="user_details()" ng-switch on="user.name" class="user">\
                            <span ng-switch-when="">log in</span>\
                            <span ng-switch-default>{{user.name}}</span>\
                        </li>\
                        <li ng-show="user.admin==1" ng-click="admin()" class="admin"><span>(admin panel)</span></li>\
                    </ul>\
                </div>',
        link:function(scope,element,attr) {
            scope.logout = function(){
                ipymeajax('/user/logout', {})
                .success(function(responseData){
                    scope.user = {name:'', admin:0, initialized:1};
                    $rootScope.model.user = scope.user;
                    $location.path('/user/logout');
                });
            }
            
            scope.shopmain = function(){
                $location.path('/shop');
            }
            
            scope.user_details = function(){
                if (scope.user.name == "") $location.path('/user/signin');
                else $location.path('/user');
            }
            
            scope.admin = function() {
                $location.path('/admin');
            }
            
            if (!$rootScope.model.user.initialized) {
                ipymeajax('/user/authenticate', {})
                .success(function(responseData){
                    $rootScope.model.user = responseData;
                    scope.user = $rootScope.model.user;
                    scope.user.initialized=1;
                });
            }
            
            $rootScope.$watch('model.user',function(newValue){
                scope.user = newValue;
            },true);
            
            scope.user = $rootScope.model.user;
            localStorage.setItem('aaaa',JSON.stringify(scope.user));
            console.log(localStorage);
            console.log(Date.now());
            
            console.log(JSON.parse(localStorage.getItem('aaaa')));
        }
    }
})
.directive('loading', function(){
   return {
       restrict:'E',
       replace:true,
       scope:{model:'=ngModel'},
       template:'<div ng-show="!model.complete" class="loading_blanket">\
                    <table>\
                        <tbody>\
                            <tr><td><p>Loading...</p></td></tr>\
                            <tr><td><progress value="model.stage" class="progress-striped progress-success active"></progress></td></tr>\
                        </tbody>\
                    <table>\
                </div>',
   } 
})
.directive('spectralbutton', function($window){
   return {
       restrict:'A',
       transclude:true,
       scope:{action:'=spectralbutton', text:'@spectralbuttontext', class:'@class'},
       template:'<div class="spectral_button {{class}}">\
                    <button ng-click="action()" class="shop">{{text}}</button>\
                </div>',
       link:function(scope, element, attr) {
            scope.div_spectro = element.find('div.spectral_button');
            scope.button_spectro = scope.div_spectro.find('button');
            var y = scope.div_spectro[0].offsetHeight/2,
                x = scope.div_spectro[0].offsetLeft+(scope.div_spectro[0].clientWidth/2),
                initOpacity = scope.button_spectro.css('opacity'),
                opacity=0;
            scope.button_spectro.bind('mousemove', function(e){
                scope.button_spectro.css('opacity',1);
                return false;
            });
            angular.element($window).bind('mousemove', function(e){
                var pos = scope.div_spectro.offset(),
                    combinedDiff = Math.abs(e.clientX+$window.pageXOffset-pos.left)+Math.abs(e.clientY+$window.pageYOffset-pos.top);
                if (combinedDiff < 150) {
                    opacity = new Number(1-(combinedDiff/150)).toFixed(2);
                    if (opacity < initOpacity){opacity = initOpacity;}
                    scope.button_spectro.css('opacity',opacity);
                } 
            });
        }
    } 
})

;
