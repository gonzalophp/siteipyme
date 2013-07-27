describe('iPymeApp.controllers', function() {
    var $routeParams = {path: ''},
    $location = {
        path: function(pathvalue) {
            $routeParams.path = pathvalue;
        },
        absUrl: function() {
            return $routeParams.path;
        }
    }
    var ipymeajax, $scope, $httpBackend;
    
    beforeEach(module('iPymeApp'));

    describe('MainMenuController', function() {
        beforeEach(inject(function($rootScope, $injector) {
            ipymeajax = $injector.get('ipymeajax');
            $scope = $rootScope.$new();
            $httpBackend = $injector.get('$httpBackend');
        }));

        afterEach(function() {
            $httpBackend.verifyNoOutstandingExpectation();
            $httpBackend.verifyNoOutstandingRequest();
        });

        it('Dectects changes on $location.path - $scope.adminpanel should be 1 when /admin is on ther url', inject(function($controller) {
            $httpBackend.whenPOST('http://server/backend.php/shop/menu/main').respond({valid_session: 0});
            $controller('MainMenuController', {
                $scope: $scope,
                ipymeajax: ipymeajax,
                $routeParams: $routeParams,
                $location: $location
            });
            $httpBackend.flush();
            
            $location.path('bbb');
            $scope.$apply();
            expect($scope.adminpanel).toEqual(0);

            $location.path('/admin/aaaaaaaaa');
            $scope.$apply();
            expect($scope.adminpanel).toEqual(1);

            $location.path('/admin');
            $scope.$apply();
            expect($scope.adminpanel).toEqual(1);

            $location.path('/admddin');
            $scope.$apply();
            expect($scope.adminpanel).toEqual(0);

            $location.path('/user');
            $scope.$apply();
            expect($scope.adminpanel).toEqual(0);
        }));
    });

    describe('CarouselItemsCtrl', function() {
        beforeEach(inject(function($rootScope, $injector) {
            ipymeajax = $injector.get('ipymeajax');
            $scope = $rootScope.$new();
            $httpBackend = $injector.get('$httpBackend');
        }));

        afterEach(function() {
            $httpBackend.verifyNoOutstandingExpectation();
            $httpBackend.verifyNoOutstandingRequest();
        });

        describe('No valid session', function() {
            it('No valid session, then redirect to /user/signin', inject(function($controller) {
                $httpBackend.whenPOST('http://server/backend.php/shop/product/getDisplayedProductsByCategory/-1').respond({valid_session: 0});
                $controller('CarouselItemsCtrl', {
                    $scope: $scope,
                    $location: $location,
                    $element: 3,
                    ipymeajax: ipymeajax,
                    imageSourceHost: 4
                });

                $httpBackend.flush();
                expect($location.absUrl()).toEqual('/user/signin');
            }));
        });


        describe('Displayed products received, so slides should be populated', function() {
            it('Slide is populated with the products received', inject(function($controller) {
                $httpBackend.whenPOST('http://server/backend.php/shop/product/getDisplayedProductsByCategory/-1').respond({displayedProducts: [{image_path: 1
                                    , id: 2
                                    , description: 3
                                    , longDescription: 4
                                    , price: 5}]});
                $controller('CarouselItemsCtrl', {
                    $scope: $scope,
                    $location: $location,
                    $element: 3,
                    ipymeajax: ipymeajax,
                    imageSourceHost: 4
                });
                $httpBackend.flush();
                expect($scope.slides[0].image).toEqual(1);
                expect($scope.slides[0].id).toEqual(2);
                expect($scope.slides[0].description).toEqual(3);
                expect($scope.slides[0].longdescription).toEqual(4);
                expect($scope.slides[0].price).toEqual(5);
            }));
        });
    });
    
    
    
    
    describe('CtrlSignUp', function() {
        var $element;
        beforeEach(inject(function($rootScope, $injector) {
            ipymeajax = $injector.get('ipymeajax');
            $element = angular.element;
            $scope = $rootScope.$new();
            $httpBackend = $injector.get('$httpBackend');
            $httpBackend.resetExpectations();
        }));

        afterEach(function() {
            $httpBackend.verifyNoOutstandingExpectation();
            $httpBackend.verifyNoOutstandingRequest();
        });
        describe('Signup process', function() {
            it('When passwords are different', inject(function($controller) {
                $httpBackend.whenPOST('http://server/backend.php/user/signup').respond({signup_success: 0, signup_fail:'error_password_does_not_match'});
                $controller('CtrlSignUp', {
                    $scope: $scope,
                    ipymeajax: ipymeajax,
                    $location: $location,
                    $element: $element,
                });
                $scope.click();
                $httpBackend.flush();
                expect($scope.error_message).toEqual('passwords are different');
            }));
            
            
            it('When username is not valid', inject(function($controller) {
                $httpBackend.whenPOST('http://server/backend.php/user/signup').respond({signup_success: 0, signup_fail:'error_constraint_u_name'});
                $controller('CtrlSignUp', {
                    $scope: $scope,
                    ipymeajax: ipymeajax,
                    $location: $location,
                    $element: $element,
                });
                $scope.click();
                $httpBackend.flush();
                expect($scope.error_message).toEqual('user name or email address are not valid');
            }));
            
            
            it('When email is not valid', inject(function($controller) {
                $httpBackend.whenPOST('http://server/backend.php/user/signup').respond({signup_success: 0, signup_fail:'error_constraint_u_email'});
                $controller('CtrlSignUp', {
                    $scope: $scope,
                    ipymeajax: ipymeajax,
                    $location: $location,
                    $element: $element,
                });
                $scope.click();
                $httpBackend.flush();
                expect($scope.error_message).toEqual('user name or email address are not valid');
            }));
            
            
            it('When signup successful', inject(function($controller) {
                $httpBackend.whenPOST('http://server/backend.php/user/signup').respond({signup_success: 1, signup_fail:''});
                $controller('CtrlSignUp', {
                    $scope: $scope,
                    ipymeajax: ipymeajax,
                    $location: $location,
                    $element: $element,
                });
                $scope.click();
                $httpBackend.flush();
                expect($scope.error_message).toEqual('Check your email inbox to complete the registration');
            }));
            
            
            it('When key 13 is pressed, $scope.click is executed', inject(function($controller) {
                $httpBackend.whenPOST('http://server/backend.php/user/signup').respond({signup_success: 1, signup_fail:''});
                $element = angular.element('<td></td>');
                
                $controller('CtrlSignUp', {
                    $scope: $scope,
                    ipymeajax: ipymeajax,
                    $location: $location,
                    $element: $element,
                });
                
                var e = jQuery.Event("keyup");
                
                spyOn($scope,'click');
                
                e.keyCode = 10; 
                $element.trigger(e);
                expect($scope.click).not.toHaveBeenCalled();
                
                
                e.keyCode = 13;
                $element.trigger(e);
                expect($scope.click).toHaveBeenCalled();
            }));
        });
    });
    
    
    
    describe('CtrlSignUpConfirmation', function() {
        var $element, location=angular.copy($location);
        beforeEach(inject(function($rootScope, $injector) {
            ipymeajax = $injector.get('ipymeajax');
            $element = angular.element;
            $scope = $rootScope.$new();
            $httpBackend = $injector.get('$httpBackend');
            $httpBackend.resetExpectations();
        }));

        afterEach(function() {
            $httpBackend.verifyNoOutstandingExpectation();
            $httpBackend.verifyNoOutstandingRequest();
        });
        describe('Signup confirmation', function() {
            xit('Signup is confirmed', inject(function($controller) {
                
                $routeParams.sessionid = 'AAABBBCCCDDD';
                $httpBackend.whenPOST('http://server/backend.php/user/signup/confirm/'+$routeParams.sessionid).respond({signup_confirmation: 1});
                
                $controller('CtrlSignUpConfirmation', {
                            $scope: $scope,
                            $location: location,
                            $routeParams: $routeParams,
                            ipymeajax: ipymeajax,
                });
                $httpBackend.flush();
                expect($scope.signup_confirmation).toEqual(1);
                
                var wait = 5500;
                setTimeout(function(){wait=0;}, wait);
                
                waitsFor(function(){return (wait==0)},'waiting', 6000);
                
                runs(function() {
                    expect(location.absUrl()).toEqual('/admin/product/catalog');
                });
            }));
            
            it('Signup is not confirmed', inject(function($controller) {
                
                $routeParams.sessionid = 'AAABBBCCCDDD';
                $httpBackend.whenPOST('http://server/backend.php/user/signup/confirm/'+$routeParams.sessionid).respond({signup_confirmation: 0});
                $controller('CtrlSignUpConfirmation', {
                    $scope: $scope,
                    $location: $location,
                    $routeParams: $routeParams,
                    ipymeajax: ipymeajax,
                });
                $httpBackend.flush();
                expect($scope.signup_confirmation).toEqual(0);
            }));
        });
    });
    
    
    describe('MenuGroup', function() {
        beforeEach(inject(function($rootScope, $injector) {
            ipymeajax = $injector.get('ipymeajax');
            $scope = $rootScope.$new();
            $httpBackend = $injector.get('$httpBackend');
            $httpBackend.resetExpectations();
        }));

        afterEach(function() {
            $httpBackend.verifyNoOutstandingExpectation();
            $httpBackend.verifyNoOutstandingRequest();
        });
        describe('MenuGroup call populates $scope.menuitems', function() {
            it('$scope.menuitems is populated', inject(function($controller) {
                
                $routeParams.list = 'AAABBBCCCDDD';
                $httpBackend.whenPOST('http://server/backend.php/shop/menu/'+$routeParams.list).respond({menuitems: 'ABC'});
                $controller('MenuGroup', {
                    $scope: $scope,
                    $routeParams: $routeParams,
                    ipymeajax: ipymeajax,
                });
                $httpBackend.flush();
                expect($scope.menuitems).toEqual('ABC');
            }));
        });
    });
    
    describe('categorytreeselectcontroller', function() {
        var $element;
        beforeEach(inject(function($rootScope, $injector) {
            ipymeajax = $injector.get('ipymeajax');
            $scope = $rootScope.$new();
            $element = angular.element('<div><div id="categorytree"></div></div>');
            $httpBackend = $injector.get('$httpBackend');
            $httpBackend.resetExpectations();
        }));

        afterEach(function() {
            $httpBackend.verifyNoOutstandingExpectation();
            $httpBackend.verifyNoOutstandingRequest();
        });
        describe('Placeholder for tree is found and populated', function() {
            it('Populating tree', inject(function($controller) {
                
                $httpBackend.whenPOST('http://server/backend.php/shop/category/get/all').respond({tree: [{key:'1', label:'2', isFolder:true},{key:'3', label:'4', isFolder:false}]});
                $controller('categorytreeselectcontroller', {
                    $scope: $scope,
                    $element: $element,
                    ipymeajax: ipymeajax,
                });
                
                $httpBackend.flush();
                
                var oTree = $("div#categorytree", $element).dynatree("getTree");
                
                expect(oTree.tnRoot.childList[0].data.key).toEqual('1');
                expect(oTree.tnRoot.childList[0].data.label).toEqual('2');
                expect(oTree.tnRoot.childList[0].data.isFolder).toEqual(true);
                expect(oTree.tnRoot.childList[1].data.key).toEqual('3');
                expect(oTree.tnRoot.childList[1].data.label).toEqual('4');
                expect(oTree.tnRoot.childList[1].data.isFolder).toEqual(false);
            }));
        });
    });
    
    
    
    
    
    
    describe('ShopController', function() {
        var $element;
        beforeEach(inject(function($rootScope, $injector) {
            ipymeajax = $injector.get('ipymeajax');
            $scope = $rootScope.$new();
            $element = angular.element('<div><div id="categorytree"></div></div>');
            $httpBackend = $injector.get('$httpBackend');
            $httpBackend.resetExpectations();
        }));

        afterEach(function() {
            $httpBackend.verifyNoOutstandingExpectation();
            $httpBackend.verifyNoOutstandingRequest();
        });
        describe('Shop Controller Initializes', function() {
            it('Initializes shop menu and set $scope.model.selected_category', inject(function($controller) {
                
                $httpBackend.whenPOST('http://server/backend.php/shop/category/menu/3').respond('ABC1');
                $httpBackend.whenPOST('http://server/backend.php/shop/product/getDisplayedProductsByCategory/-1').respond({displayedProducts:'ABC2'});
                $httpBackend.whenPOST('http://server/backend.php/shop/category/getAllAvailableAttributeValuesRelated/-1,').respond({category_attribute:'ABC3'});
                
                $controller('ShopController', {
                    $scope: $scope,
                    $element: $element,
                    $location:$location,
                    ipymeajax: ipymeajax,
                });
                
                expect($scope.model.loading).toEqual({complete:false, stage:30});
                
                $httpBackend.flush(1);
                expect($scope.model.loading).toEqual({complete:false, stage:50});
                expect($scope.menutree).toEqual('ABC1');
                
                $httpBackend.flush(1);
                expect($scope.model.displayedProducts).toEqual('ABC2');
                expect($scope.model.loading).toEqual({complete:false, stage:70});
                expect($scope.waitingUpdate).toEqual(true);
                
                $httpBackend.flush(1);
                expect($scope.model.loading).toEqual({complete:true, stage:90});
                expect($scope.waitingUpdate).toEqual(false);
                expect($scope.model.relativeAttributes).toEqual('ABC3');
            }));
        });
        
        
        
        describe('Shop Controller - test $scope methods', function() {
            beforeEach(inject(function($rootScope, $injector,$controller) {
                $httpBackend.resetExpectations();
                $httpBackend.expectPOST('http://server/backend.php/shop/category/menu/3').respond('ABC1');
                $controller('ShopController', {
                    $scope: $scope,
                    $element: $element,
                    $location:$location,
                    ipymeajax: ipymeajax,
                });
            }));
        
            it('tests attributevalueclick when attribute found in $scope.model.relativeAttributes', function() {
                
                $httpBackend.expectPOST('http://server/backend.php/shop/product/getDisplayedProductsByCategory/-1').respond({displayedProducts:'ABC2'});
                $httpBackend.expectPOST('http://server/backend.php/shop/category/getAllAvailableAttributeValuesRelated/-1,')
                        .respond({category_attribute:[{attributes:[{id:1,value:2,selected:0}]}]});
                
                $httpBackend.flush();
                
                $httpBackend.expectPOST('http://server/backend.php/shop/product/getDisplayedProductsByAttributeValue')
                .respond({displayedProducts:'ABC4'});
            
                $scope.attributevalueclick({id:1,value:2});
                expect($scope.waitingUpdate).toEqual(true);
                
                $httpBackend.flush();
                expect($scope.model.displayedProducts).toEqual('ABC4');
                expect($scope.waitingUpdate).toEqual(false);
            });
            
            it('tests attributevalueclick when attribute not found in $scope.model.relativeAttributes', function() {
                $scope.model.selected_category = {key:555};
                $httpBackend.expectPOST('http://server/backend.php/shop/product/getDisplayedProductsByCategory/555').respond({displayedProducts:'ABC2'});
                $httpBackend.expectPOST('http://server/backend.php/shop/category/getAllAvailableAttributeValuesRelated/555,')
                        .respond({category_attribute:[{attributes:[{id:1,value:2,selected:0}]}]});
                
                $httpBackend.flush();
                $httpBackend.expectPOST('http://server/backend.php/shop/product/getDisplayedProductsByCategory/555').respond({displayedProducts:'ABC4'});
                $scope.attributevalueclick({id:3,value:4});
                expect($scope.waitingUpdate).toEqual(true);

                $httpBackend.flush();
                expect($scope.model.displayedProducts).toEqual('ABC4');
                expect($scope.waitingUpdate).toEqual(false);
            });
            
            
            it('tests $watch for selected_category', function() {
                $httpBackend.expectPOST('http://server/backend.php/shop/product/getDisplayedProductsByCategory/-1').respond({displayedProducts:'ABC2'});
                $httpBackend.expectPOST('http://server/backend.php/shop/category/getAllAvailableAttributeValuesRelated/-1,')
                        .respond({category_attribute:[{attributes:[{id:1,value:2,selected:0}]}]});
                
                $httpBackend.flush();
                $httpBackend.expectPOST('http://server/backend.php/shop/product/getDisplayedProductsByCategory/555').respond({displayedProducts:'ABC4'});
                $httpBackend.expectPOST('http://server/backend.php/shop/category/getAllAvailableAttributeValuesRelated/555,')
                        .respond({category_attribute:[{attributes:[{id:5,value:6,selected:0}]}]});
                $scope.model.selected_category = {key:555};
                $scope.$digest();
                
                $httpBackend.flush();
                
                expect($scope.model.relativeAttributes ).toEqual([{attributes:[{id:5,value:6,selected:0}]}]);
            });
            
            
            it('tests addToBasket', function() {
                $httpBackend.expectPOST('http://server/backend.php/shop/product/getDisplayedProductsByCategory/-1').respond({displayedProducts:'ABC2'});
                $httpBackend.expectPOST('http://server/backend.php/shop/category/getAllAvailableAttributeValuesRelated/-1,')
                        .respond({category_attribute:[{attributes:[{id:1,value:2,selected:0}]}]});
                $httpBackend.flush();
                
                $scope.model.basket = {id:0
                                        ,total:0
                                        ,products:[]
                                        ,initialized:false}
                
                $httpBackend.expectPOST('http://server/backend.php/shop/basket/get').respond({valid_session:1, basket:{id:777, products:[]}});
                $scope.basketpersist(true);
                $httpBackend.flush();
                
                expect($scope.model.basket.products.length).toEqual(0);
                $scope.addToBasket({id:1, description:2, quantity:3, price:4, currency:5});
                expect($scope.model.basket.products.length).toEqual(1);
                expect($scope.model.basket.products[0]).toEqual({ bl_product : 1, p_description : 2, bl_quantity : 3, p_price : 4, total : 12, c_name : 5 });
                
                /* Directive must update total price. Controller should not update it*/
                $scope.addToBasket({id:1, description:2, quantity:100, price:4, currency:5});
                expect($scope.model.basket.products.length).toEqual(1);
                expect($scope.model.basket.products[0]).toEqual({ bl_product : 1, p_description : 2, bl_quantity : 103, p_price : 4, total : 12, c_name : 5 });
                
            });
            
        });
        
    });
    
    
    describe('productController', function() {
        var imageSourceHost;
        beforeEach(inject(function($rootScope, $injector) {
            ipymeajax = $injector.get('ipymeajax');
            imageSourceHost = $injector.get('imageSourceHost');
            $scope = $rootScope.$new();
            $httpBackend = $injector.get('$httpBackend');
            $httpBackend.resetExpectations();
        }));

        afterEach(function() {
            $httpBackend.verifyNoOutstandingExpectation();
            $httpBackend.verifyNoOutstandingRequest();
        });
        describe('Shop Products', function() {
            it('Product properties initialized', inject(function($controller) {
                
                $routeParams = {id:'ABC'}
                $httpBackend.expectPOST('http://server/backend.php/shop/product/get/'+$routeParams.id).respond({product: {p_id:111, p_description:'2', price:3}});
                $controller('productController', {
                    $scope: $scope,
                    $location:$location,
                    ipymeajax: ipymeajax,
                    $routeParams:$routeParams,
                    imageSourceHost:imageSourceHost
                });
                
                $httpBackend.expectPOST('http://server/backend.php/shop/basket/get')
                        .respond({basket:{id:222, products: [{bl_product:11
                                                            , p_description:22
                                                            , bl_quantity:33
                                                            , p_price:33*44
                                                            , c_name:55}]}});
                /* Initialize basket*/                                        
                $scope.basketpersist(true);
                expect($scope.basketpersist.basketWaitingUpdate).toEqual(true);
                $httpBackend.flush();
                expect($scope.basketpersist.basketWaitingUpdate).toEqual(false);
                
                expect($scope.model.product).toEqual({p_id:111, p_description:'2', price:3, quantity:1});
                expect($scope.model.basket.products.length).toEqual(1);
               
                $scope.addbutton({p_id:111, p_description:'2', p_price:3, quantity:5});
                expect($scope.model.basket.products[1]).toEqual({bl_product:111
                                                                , p_description:'2'
                                                                , bl_quantity:5
                                                                , p_price:3
                                                                , c_name:undefined});
                                                            
                $scope.addbutton({p_id:222, p_description:'222222', p_price:10, quantity:2, c_name:999});
                expect($scope.model.basket.products[2]).toEqual({bl_product:222
                                                                , p_description:'222222'
                                                                , bl_quantity:2
                                                                , p_price:10
                                                                , c_name:999});
                expect($scope.model.basket.products.length).toEqual(3);
                
                
                
                
                $httpBackend.expectPOST('http://server/backend.php/shop/basket/save')
                        .respond({basket:{id:222, products: [{bl_product:11
                                                            , p_description:22
                                                            , bl_quantity:33
                                                            , p_price:33*44
                                                            , c_name:55},
                                                            {bl_product:111
                                                            , p_description:'2'
                                                            , bl_quantity:5
                                                            , p_price:3
                                                            , c_name:undefined},
                                                            {bl_product:222
                                                            , p_description:'222222'
                                                            , bl_quantity:2
                                                            , p_price:10
                                                            , c_name:999}
                                                        ]}});
                $scope.basketpersist(false);
                $httpBackend.flush();
                
                expect($scope.model.basket.products.length).toEqual(3);
            }));
        });
    });
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    describe('ShopMenuController', function() {
        beforeEach(inject(function($rootScope, $injector) {
            ipymeajax = $injector.get('ipymeajax');
            $scope = $rootScope.$new();
            $httpBackend = $injector.get('$httpBackend');
            $httpBackend.resetExpectations();
        }));

        afterEach(function() {
            $httpBackend.verifyNoOutstandingExpectation();
            $httpBackend.verifyNoOutstandingRequest();
        });
        
        describe('Shop Menu controller', function() {
            it('Shop Menu is initialized with data from the backend', inject(function($controller) {
                
                $httpBackend.expectPOST('http://server/backend.php/shop/menu/shop').respond('ABCDE');
                $controller('ShopMenuController', {
                    $scope: $scope,
                    ipymeajax: ipymeajax,
                });
                
                $httpBackend.flush();
                expect($scope.menutree).toEqual('ABCDE');
                
            }));
            
            
        });
    });
    
    
    describe('logoutCtrl', function() {
        describe('logoutCtrl', function() {
            it('Redirects to /shop', inject(function($controller) {
                $controller('logoutCtrl', {
                    $location: $location,
                });
                expect($location.absUrl()).toEqual('/shop');
            }));
        });
    });
    
    
    
    
    
    describe('basketCtrl', function() {
        beforeEach(inject(function($rootScope, $injector) {
            ipymeajax = $injector.get('ipymeajax');
            $scope = $rootScope.$new();
            $httpBackend = $injector.get('$httpBackend');
            $httpBackend.resetExpectations();
        }));

        afterEach(function() {
            $httpBackend.verifyNoOutstandingExpectation();
            $httpBackend.verifyNoOutstandingRequest();
        });
        
//        describe('Shop Menu controller', function() {
//            it('Shop Menu is initialized with data from the backend', inject(function($controller) {
//                
//                $httpBackend.expectPOST('http://server/backend.php/shop/menu/shop').respond('ABCDE');
//                $controller('basketCtrl', {
//                    $scope: $scope,
//                    ipymeajax: ipymeajax,
//                });
//                
//                $httpBackend.flush();
//                expect($scope.menutree).toEqual('ABCDE');
//                
//            }));
//            
//            
//        });



    });
});
