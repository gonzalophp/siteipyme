'use strict';
    
angular.module('iPymeApp')
.controller('MainMenuController',['$scope',"ipymeajax",'$routeParams','$location', function ($scope,ipymeajax,$routeParams,$location) {
    ipymeajax('/shop/menu/main', {})
    .success(function(responseData){
        $scope.menutree = responseData;
    });
    
    $scope.routeParams = $routeParams;
    
    $scope.$watch('routeParams', function(){
        $scope.adminpanel = ($location.absUrl().search('/admin') >= 0) ? 1:0;
    }, true);
}])
.controller('AdminListController',['$scope','$element','$dialog','$routeParams','ipymeajax', function($scope,$element,$dialog,$routeParams,ipymeajax){
    $scope.selectedItems = [];
    $scope.adminList = $routeParams.list;
    $scope.datagrid = [];
    $scope.columnDefs  = [];
    
    $scope.gridOptions = {
        enableColumnResize:true,
        enablePaging:true,
        enableColumnReordering:true,
        showFooter:true,
        multiSelect:false,
        pagingOptions:{ pageSizes: [5, 10, 20]
                        , pageSize: 10
                        , totalServerItems: 0
                        , currentPage: 1 },
        data: 'datagrid',
        columnDefs:'columnDefs',
        selectedItems: $scope.selectedItems,
    }
    
    $scope.$watch(function(){return {pagingoptions:$scope.gridOptions.pagingOptions, categoryselected:$scope.categoryselected}}
                , function (newVal, oldVal) {
                    if (newVal.pagingoptions.currentPage == oldVal.pagingoptions.currentPage) {
                        if ((!oldVal.categoryselected) || (newVal.categoryselected.id != oldVal.categoryselected.id)){
                            $scope.gridOptions.pagingOptions.currentPage = 1;
                        }
                    }
            
            var serviceUrl = '/shop/'+$scope.adminList+((newVal.categoryselected)?'/getProductsByCategory/'+newVal.categoryselected.id:'');
            ipymeajax(serviceUrl
                ,{pagesize:$scope.gridOptions.pagingOptions.pageSize
                 ,page:$scope.gridOptions.pagingOptions.currentPage}) 
            .success(function(responseData){
                $scope.columnDefs = responseData.columnDefs;
                $scope.datagrid = responseData.datagrid;
                $scope.gridOptions.$gridScope.totalServerItems = (responseData.datagrid) ? responseData.datagrid[0].rowcount:0;
            });
    }, true);

    
        
    $scope.openDialog = function(start_empty, form_template, buttons, readonly) { 
        var dialog = $dialog.dialog({templateUrl: 'tpl/forms/ng.'+form_template+'.tpl',
                                     controller: 'FormDialogController'});

        if ((start_empty==0) && ($scope.selectedItems.length == 0)) return;
        dialog.buttons=buttons;
        dialog.readonly=readonly;
        dialog.formContext = $routeParams.list;
        dialog.selectedItems = $scope.selectedItems[0];
        
        dialog.data = {fields: ((start_empty==0) && ($scope.selectedItems.length > 0)) ? $scope.selectedItems[0] : {}
                     , categoryselected: (start_empty==0) ? {id:$scope.selectedItems[0].p_category,category:$scope.selectedItems[0].p_category_name}:$scope.categoryselected};
                
        dialog.open().then(function(oReturn) {
            if (oReturn && oReturn.success == 1) {
                if (oReturn.button == 1){
                    if (start_empty==1){
                        if (typeof $scope.datagrid == 'undefined') {
                            $scope.datagrid = [];
                        }
                        $scope.datagrid.push(oReturn.response);
                    }
                }
                else if (oReturn.button == 2){
                    var grid_id = $scope.selectedItems[0].grid_id,
                        datagrid = $scope.datagrid;
                    for(var key in datagrid){
                        if (datagrid[key].grid_id == grid_id){
                            datagrid.splice(key,1);
                            $scope.gridOptions.selectItem(key, false);
                            break;
                        }
                    }
                }
            }
        });
    } 
}])
.controller('FormDialogController',['$scope','dialog','ipymeajax','imageSourceHost', function FormDialogController($scope, dialog,ipymeajax,imageSourceHost){
    $scope.dialogForm = {
        readonly:(dialog.readonly==1),
        button_actions:{},
        data: dialog.data,
        data_backup: angular.copy(dialog.data),
        action: {cancel:0, save:1, delete:2},
        button:{
            cancel: function(){
                for(var key in $scope.dialogForm.data_backup.fields) dialog.data.fields[key]=$scope.dialogForm.data_backup.fields[key];
                closeDialog({button:$scope.dialogForm.action.cancel, success:1,response:null});
            },   
            save: function(){
                ipymeajax('/shop/'+dialog.formContext+'/save', dialog.data.fields)
                .success(function(responseData){
                    if (responseData.success == 1){
                        closeDialog({button:$scope.dialogForm.action.save
                            , success:responseData.success
                            ,response:responseData});
                    }
                });
            },
            delete: function(){
                ipymeajax('/shop/'+dialog.formContext+'/delete', dialog.data.fields)
                .success(function(responseData){
                    if (responseData.success == 1){
                        closeDialog({button:$scope.dialogForm.action.delete
                                   , success:responseData.success
                                    ,response:responseData});
                    }
                });
            }
        }
    }
    
    $scope._imagechanged = function(oFormData) {
        ipymeajax('/shop/imageupload', oFormData, true)
        .success(function(responseData){
            setTimeout(function(){$scope.dialogForm.data.fields.p_image_path=responseData.imagepath},500);
        });
    }
    if (dialog.formContext == 'product'){
        dialog.data.fields.p_category= dialog.data.categoryselected.id;
        dialog.data.fields.p_category_name= dialog.data.categoryselected.category;

        $scope.product = {attributes: []
                          ,categoryselected: dialog.data.categoryselected};

        ipymeajax('/shop/category/getAttributeValuesRelated/'+dialog.data.fields.p_category+','+dialog.data.fields.p_id, {})
        .success(function(responseData){
            if (responseData.success == 1){
                dialog.data.fields.category_attribute = responseData.category_attribute;
            }
        });
        ipymeajax('/shop/currency/get', {})
        .success(function(responseData){
            if (responseData.success == 1){
                dialog.data.currencies = responseData.currencies;
            }
        });
    }
        
    $scope.do = function(e,task){
        e.preventDefault();
        $scope.dialogForm.button[task]();
    }

    for(var key in dialog.buttons) {
        $scope.dialogForm.button_actions[key] = dialog.buttons[key];
    }

    var closeDialog = function(returnCode){
        dialog.close(returnCode);
    };
}])
.controller('CtrlSignin', ['$scope','ipymeajax','$location','$cookieStore', '$element','$rootScope', function ($scope,ipymeajax,$location,$cookieStore,$element,$rootScope) {
    $scope.user_data = { user_name:$cookieStore.get('ipyme_u_n')
                        , user_password:$cookieStore.get('ipyme_u_p')
                        , user_remember:false};

    $scope.click = function() {
        var hash_password = ($scope.user_data.user_password!=$cookieStore.get('ipyme_u_p'))?CryptoJS.SHA1($scope.user_data.user_password).toString():$scope.user_data.user_password;
        ipymeajax('/user/signin', {user_name:$scope.user_data.user_name
                                  ,hash_user_password:hash_password})
        .success(function(responseData){
            if (responseData.u_authenticated == 1){
                
                console.log(responseData);
                    $rootScope.model.user = responseData;
                    $rootScope.model.user.initialized=1;
                
                
                $scope.user_data.user_sessionid = responseData.u_sessionid;
                if ($scope.user_data.user_remember) {
                    $cookieStore.put('ipyme_u_n',$scope.user_data.user_name);
                    $cookieStore.put('ipyme_u_p',hash_password);
                }
                $location.path( "/" );
            }
        });
    }
    
    $element.bind('keyup', function(e){(e.keyCode==13) && $scope.click();});
    
    $scope.clear = function() {
        $cookieStore.remove('ipyme_u_n');
        $cookieStore.remove('ipyme_u_p');
        $cookieStore.remove('PHPSESSID');
        
        $scope.user_data = { user_name:null
                            , user_password:null
                            , user_remember:null};

    }
}])
.controller('CtrlSignUp', ['$scope','ipymeajax','$location','$element', function ($scope,ipymeajax,$location,$element) {
    $scope.user_data = {
        user_name:''
        , user_email:''
        , user_password:''
        , user_password2:''};

    $scope.click = function() {
        ipymeajax('/user/signup', $scope.user_data)
        .success(function(responseData){
            if (responseData.signup_success == 1){
                $scope.error_message = 'Check your email inbox to complete the registration';
                setTimeout($location.path("#/user/signin"), 3000);
            }
            else {
                if (responseData.signup_fail == 'error_password_does_not_match'){
                    $scope.error_message = 'passwords are different';
                }
                else if ((responseData.signup_fail == 'error_constraint_u_name') || (responseData.signup_fail == 'error_constraint_u_email')){
                    $scope.error_message = 'user name or email address are not valid';
                }
            }
        });
    }
    
    $element.bind('keyup', function(e){(e.keyCode==13) && $scope.click();});
}])
.controller('CtrlSignUpConfirmation', ['$scope','$location','$routeParams','ipymeajax', function ($scope,$location,$routeParams,ipymeajax) {
    ipymeajax('/user/signup/confirm/'+$routeParams.sessionid, {})
    .success(function(responseData){
        $scope.signup_confirmation=responseData.signup_confirmation;
        if ($scope.signup_confirmation==1) {
            setTimeout(function(){$scope.$apply(function() { $location.path("/admin/product/catalog")})},5000);
        }
    });
}])
.controller('MenuGroup', ['$scope','$routeParams','ipymeajax', function($scope,$routeParams,ipymeajax) {
    ipymeajax('/shop/menu/'+$routeParams.list, {})
    .success(function(responseData){ 
        $scope.menuitems = responseData.menuitems;
    });
}])
.controller('categorytreeeditcontroller', ['$scope','$element','ipymeajax', function($scope,$element,ipymeajax){
    
    $("div#categorytree",$element).dynatree({
        title: "Event samples",
        debugLevel:0,
        fx: { height: "toggle", duration: 200 },
        clickFolderMode:1,
        editNode: function(node) {
            var prevTitle = node.data.title,
                    tree = node.tree;
            $(".dynatree-title", node.span).html("<input id='editNode' value='" + prevTitle + "'>");
            $("input#editNode")
            .focus()
            .bind('click', function(event) {}, false)
            .bind('keydown',function(event) {
                switch (event.which) {
                    case 27: // [esc]
                        $("input#editNode").val(prevTitle);
                        this.blur();
                        break;
                    case 13: // [enter]
                        this.blur();
                        break;
                    case 37: // [Cursor left]
                        this.selectionEnd = --this.selectionStart;
                        return false;
                    break;
                    case 39: // [Cursor right]
                        this.selectionStart = ++this.selectionEnd;
                        return false;
                    break;
                    case 8: // [backspace]
                        var selStart = this.selectionStart-1;
                        this.value = this.value.substring(0,selStart)+this.value.substring(this.selectionEnd);
                        this.selectionStart=this.selectionEnd=selStart;
                        return false;
                    break;
                }
            })
            .bind('blur', function(event) {
                var originalTitle = node.data.title;
                var newTitle = $("input#editNode").val();
                if (newTitle == ''){
                    if (node.parent.childList.length == 1){
                        node.parent.data.isFolder = false;
                    }
                    
                    $scope.removeCategory(node.data.key);
                    node.getParent().focus();
                    node.remove();
                }
                else {
                    if (originalTitle == ''){
                        node.parent.data.isFolder = true;
                        node.parent.render();
                    }
                    
                    if (newTitle != originalTitle){
                        node.data.edited = 1;
                    }
                    node.setTitle(newTitle);
                    node.focus();
                }
                
                return false;
            });
        },
        onDblClick: function(node, event) {
            this.options.editNode(node);
            return true;
        },
        onActivate:function(node){
            $scope.loadAttributes(node.data.key);
            return false;
        },
        onSelect:function(flag, node){
        },
        onFocus: function(node) {
        },
        onBlur: function(node) {
        },
        dnd: {
            onDragStart: function(node) {
                return true;
            },
            onDragStop: function(node) {
            },
            autoExpandMS: 1000,
            preventVoidMoves: true, // Prevent dropping nodes 'before self', etc.
            onDragEnter: function(node, sourceNode) {
                return true;
            },
            onDragOver: function(node, sourceNode, hitMode) {
                if (node.isDescendantOf(sourceNode)) {
                    return false;
                }
                if (!node.data.isFolder && hitMode === "over") {
                    return "after";
                }
            },
            onDrop: function(node, sourceNode, hitMode, ui, draggable) {
                sourceNode.move(node, hitMode);
                node.expand(true);
            },
            onDragLeave: function(node, sourceNode) {
            }
        },
        onKeydown: function(node, event) {
            switch (event.which) {
                case 113: // [F2]
                    this.options.editNode(node);
                    return false;
                case 13: // [enter]
                    var isMac = /Mac/.test(navigator.platform);
                    if (isMac) {
                        this.options.editNode(node);
                        return false;
                    }
            }
            
        }
    });
    
    $scope.addAttribute = function() {
        if ($scope.model.current_node.editing == 0){
            var oUpdatedNode = JSON.parse(JSON.stringify($scope.model.current_node));
            oUpdatedNode.editing = 1;
            $scope.model.updated_nodes.push(oUpdatedNode);
            $scope.model.current_node = oUpdatedNode;
        }

        var oAttribute = {pca_id:-1, pca_attribute:''};
        $scope.model.current_node.attributes.values.push(oAttribute);
    };
    
    $scope.loadAttributes = function(key) {
        var bFound = false;
        for(var i in $scope.model.added_nodes){
            if ($scope.model.added_nodes[i].key == key){
                $scope.model.current_node = $scope.model.added_nodes[i];
                
                if(!$scope.$$phase) {$scope.$apply();}
                bFound = true;
                break;
            }
        }
        if (!bFound){
            for(var i in $scope.model.updated_nodes){
                if ($scope.model.updated_nodes[i].key == key){
                    $scope.model.current_node = $scope.model.updated_nodes[i];
                    if(!$scope.$$phase) {$scope.$apply();}
                    bFound = true;
                    break;
                }
            }
        }
        if (!bFound){
            ipymeajax('/shop/category/getattribute/'+key, {})
            .success(function(responseData){
                var oCurrentNode = {editing:0, key:key,attributes:{removed:[], values:responseData.category_attribute}}
                $scope.model.current_node = oCurrentNode;
                
            });
        }
    }
    
    $scope.removeAttribute = function(index) {
        if ($scope.model.current_node.editing == 0){
            var oUpdatedNode = JSON.parse(JSON.stringify($scope.model.current_node));
            oUpdatedNode.editing = 1;
            $scope.model.updated_nodes.push(oUpdatedNode);
            $scope.model.current_node = oUpdatedNode;
        }
        
        $scope.model.current_node.attributes.removed.push($scope.model.current_node.attributes.values[index].pca_id);
        $scope.model.current_node.attributes.values.splice(index, 1);
    };
    
    $scope.editedAttribute = function() {
        if ($scope.model.current_node.editing == 0){
            var oUpdatedNode = JSON.parse(JSON.stringify($scope.model.current_node));
            oUpdatedNode.editing = 1;
            $scope.model.updated_nodes.push(oUpdatedNode);
            $scope.model.current_node = oUpdatedNode;
        }
    }
    
    $scope.newCategory = function() {
        var oNode = $scope.model.tree.getActiveNode();
        if (oNode == null) {
            oNode = $scope.model.tree.getRoot();
        }
        var childNode = oNode.addChild({title: ""});
        oNode.expand(true);
        $scope.model.added_nodes.push({key:childNode.data.key
                                     , attributes:{removed:[], values:[]}});
        $scope.model.current_node = $scope.model.added_nodes[$scope.model.added_nodes.length-1];
        childNode.activate();
        oNode.tree.options.editNode(childNode);
    }
    
    $scope.removeCategory = function(key) {
        var bFound = false;
        for(var i in $scope.model.added_nodes){
            if ($scope.model.added_nodes[i].key == key){
                $scope.model.added_nodes.splice(i,1);
                bFound = true;
                break;
            }
        }
        
        if (!bFound){
            for(var i in $scope.model.updated_nodes){
                if ($scope.model.updated_nodes[i].key == key){
                    $scope.model.updated_nodes.splice(i,1);
                    break;
                }
            }
        }
    }
    
    $scope.saveCategories = function() { 
        ipymeajax('/shop/category/save', {tree:$scope.model.tree.toDict()
                                        , added_nodes: $scope.model.added_nodes
                                        , updated_nodes: $scope.model.updated_nodes})
        .success(function(responseData){
            $scope.model = {tree: $("div#categorytree").dynatree("getTree")
                            ,added_nodes: []
                            ,updated_nodes: []
                            ,categoryattributes:{}
                            ,current_node:{}}
            var root = $scope.model.tree.getRoot();
            root.removeChildren();
            root.addChild(responseData.tree);
            root.getChildren()[0].activate();
        });
    };
    
    $scope.getTreeValues = function() {
        ipymeajax('/shop/category/get/all', {})
        .success(function(responseData){
            $scope.model = {tree: $("div#categorytree").dynatree("getTree")
                            ,added_nodes: []
                            ,updated_nodes: []
                            ,categoryattributes:{}
                            ,current_node:{}}
                
            var root = $scope.model.tree.getRoot();
            root.removeChildren();
            root.addChild(responseData.tree);
        });
    }
    
    $scope.getTreeValues();
    
}])

.controller('CarouselItemsCtrl', ['$scope','$element','$location','ipymeajax','imageSourceHost', function($scope,$element,$location,ipymeajax,imageSourceHost){    
    $scope.slides = [];
    $scope.imageSourceHost=imageSourceHost;
    ipymeajax('/shop/product/getDisplayedProductsByCategory/-1', {pagesize:5, page:1})
    .success(function(responseData){
        if (responseData.valid_session == 0) {
            $location.path('/user/signin');
        }
        if (responseData.displayedProducts){
            for(var i=0; i<responseData.displayedProducts.length; i++) {
                $scope.slides.push({image:responseData.displayedProducts[i].image_path
                                  , id: responseData.displayedProducts[i].id
                                  , description: responseData.displayedProducts[i].description
                                  , longdescription: responseData.displayedProducts[i].longDescription
                                  , price: responseData.displayedProducts[i].price});
            }
        }
    });
}])
.controller('categorytreeselectcontroller', ['$scope', '$element', 'ipymeajax', function($scope, $element, ipymeajax) {
    var oTree = $("div#categorytree", $element).dynatree({
        title: "Event samples",
        debugLevel: 0,
        fx: {height: "toggle", duration: 200},
        clickFolderMode: 1,
        onActivate: function(node) {
            $scope.$parent.$parent.categoryselected = {id:node.data.key,category:node.data.title};
            $scope.$root.$$phase || $scope.$root.$apply();
        },
    }).dynatree("getTree");
    
    ipymeajax('/shop/category/get/all', {})
    .success(function(responseData) {
        oTree.getRoot().addChild(responseData.tree);
    });
}])
.controller('ShopController',['$scope','$element','$location',"ipymeajax", function($scope,$element,$location,ipymeajax) {
    $scope.model = {}
    $scope.model.loading = {complete:false, stage:30};
    
    ipymeajax('/shop/category/menu/3', {})
    .success(function(responseData){
        $scope.menutree = responseData;
        $scope.model.loading.stage+=20;
    });
    
    $scope.attributevalueclick = function(attribute) {
        var rel = $scope.model.relativeAttributes
          , selected = 0;
        
        for(var k1 in rel){
            for(var k2 in rel[k1].attributes){
                (rel[k1].attributes[k2].id == attribute.id) && (rel[k1].attributes[k2].value == attribute.value) && (rel[k1].attributes[k2].selected ^= 1);
                (rel[k1].attributes[k2].selected == 1) && (selected++);
            }
        }
        $scope.waitingUpdate = true;
        ((selected) ?
        (ipymeajax('/shop/product/getDisplayedProductsByAttributeValue', $scope.model.relativeAttributes)):
        ipymeajax('/shop/product/getDisplayedProductsByCategory/'+$scope.model.selected_category.key, {pagesize:10, page:1}))
        .success(function(responseData){
            $scope.model.displayedProducts = responseData.displayedProducts;
            $scope.waitingUpdate = false;
        });
    }
    
    $scope.addToBasket = function(product) {
        var bInBasket = false, p = $scope.model.basket.products;
        for(var i in p){
            if (p[i].bl_product == product.id) {
                p[i].bl_quantity = parseFloat(p[i].bl_quantity)+parseFloat(product.quantity);
                bInBasket = true;
                break;
            }
        }
        
        bInBasket || $scope.model.basket.products.push({bl_product:product.id
                                                        , p_description:product.description
                                                        , bl_quantity:product.quantity
                                                        , p_price:product.price
                                                        , total:product.quantity*product.price
                                                        , c_name:product.currency});
    }
    
    $scope.basketpersist = function(initialize){
        $scope.basketpersist.basketWaitingUpdate = true;
        if (initialize){
            ipymeajax('/shop/basket/get', {})
            .success(function(responseData){
                if (responseData.valid_session != 0) {
                    $scope.model.basket.id          = responseData.basket.id;
                    $scope.model.basket.products    = responseData.basket.products;
                    $scope.model.basket.initialized = true;
                }
                $scope.basketpersist.basketWaitingUpdate = false;
            })
        }
        else {
            ipymeajax('/shop/basket/save', $scope.model.basket)
            .success(function(responseData){
                if (responseData.valid_session != 0) {
                    $scope.model.basket.id = responseData.basket.id;
                }
                $scope.basketpersist.basketWaitingUpdate = false;
            })
        }
    }
    $scope.model.selected_category = {key:-1};
    $scope.$watch('model.selected_category', function(selected_category){
       $scope.waitingUpdate = true;
       ipymeajax('/shop/product/getDisplayedProductsByCategory/'+selected_category.key, {pagesize:10, page:1})
       .success(function(responseData){
            $scope.model.loading.stage+=20;
            $scope.model.displayedProducts = responseData.displayedProducts;
            ipymeajax('/shop/category/getAllAvailableAttributeValuesRelated/'+selected_category.key+',', {})
            .success(function(responseData){
                $scope.model.loading.stage+=20;
                $scope.waitingUpdate = false;
                $scope.model.relativeAttributes = responseData.category_attribute;
                $scope.model.loading.complete=true;  
            });
        });
    });
    
    $scope.menuclick = function(menuitem) {
        $scope.model.selected_category = menuitem;
        $scope.$$phase || $scope.$apply();
    }
}])
.controller('imageuploadCtrl', ['$scope','$element','ipymeajax', function ($scope, $element,ipymeajax) {
    $scope._imagechanged = function(oFormData) {
        ipymeajax('/shop/imageupload', oFormData, true)
        .success(function(responseData){
             $scope.imagepath = responseData.imagepath;
        });
    }
}])
.controller('basketCtrl', ['$scope','ipymeajax','buttonset','opendialog', function ($scope, ipymeajax,buttonset,opendialog) {
    var select2CountryFormat=function(state) {
                                    if (!state) return;
                                    return '<img class="flag flag-'+state.id+'"/>'+state.text;
                                }
                                
    $scope.model = {
        iscollapsed:true,
        user_details:{
        },
        titles:['Mr.','Mrs.','Ms.'],
        countries:{available:[],
                    selected:null,
                    selectcountryoptions:{allowClear: true, 
                                            placeholder: "Select country",
                                            formatResult: select2CountryFormat,
                                            formatSelection: select2CountryFormat,
                                            escapeMarkup: function(m) { return m; },},},
    }
    
    $scope.basketpersist = function(initialize){
        if (initialize){
            ipymeajax('/shop/basket/get', {})
            .success(function(responseData){
                if (responseData.valid_session != 0) {
                    $scope.model.basket.id          = responseData.basket.id;
                    $scope.model.basket.products    = responseData.basket.products;
                    $scope.model.basket.initialized = true;
                }
            });
        }
        else {
            ipymeajax('/shop/basket/save', $scope.model.basket)
            .success(function(responseData){
                if (responseData.valid_session != 0) $scope.model.basket.id = responseData.basket.id;
            });
        }
    }
    
    $scope.confirm = function() {
        console.log($scope.model);
        ipymeajax('/shop/payment/pay', $scope.model)
        .success(function(responseData){
            $scope.basketpersist = function(){}
            console.log(responseData);
        });
    }
    
                                
    ipymeajax('/shop/user/getCountries', {})
    .success(function(responseData){
        $scope.model.countries.available = responseData.available;
    });
    
    $scope.addInvoiceAddress = function() {
        var aData = {countries:$scope.model.countries,
                    fields:{ address_detail_ad_country:{country_c_code: "gb"}}};
        opendialog($scope, aData,1, 'address', buttonset(['save','cancel']), false,'address_selected');
    }
    
    $scope.editInvoiceAddress = function() {
         var aData = {countries:$scope.model.countries,
                    fields:$scope.model.user_details.address_selected};
        opendialog($scope, aData, 0, 'address', buttonset(['save','cancel']), false,'address_selected');
    }
    
    $scope.addDeliveryAddress = function() {
        var aData = {countries:$scope.model.countries,
                    fields:{ address_detail_ad_country:{country_c_code: "gb"}}};
        opendialog($scope, aData,1, 'address', buttonset(['save','cancel']), false,'address_delivery');
    }
    
    $scope.editDeliveryAddress = function() {
         var aData = {countries:$scope.model.countries,
                    fields:$scope.model.user_details.address_delivery};
        opendialog($scope, aData, 0, 'address', buttonset(['save','cancel']), false,'address_delivery');
    }
    
    $scope.$watch('model.user_details.addresses', function(newValue, oldValue) {
        console.log(newValue, oldValue);
        if (oldValue && (oldValue.length == 0) && (newValue.length > 0)){
            $scope.model.user_details.address_delivery = newValue[0];
        }
    }, true);
    
    $scope.addPayment = function() {
        var aData = {card_vendors:$scope.model.card_vendors,
                    fields:{}};
        opendialog($scope, aData,1, 'card', buttonset(['save','cancel']), false,'card_selected');
    }
    
    
    $scope.editPayment = function() {
        var aData = {card_vendors:$scope.model.card_vendors,
                    fields:$scope.model.user_details.card_selected};
        opendialog($scope, aData, 0, 'card', buttonset(['save','cancel']), false,'card_selected');
    }
    
    $scope.editAccount = function() {
         var aData = {titles:$scope.model.titles,
                    fields:$scope.model.user_details.people_selected};
        opendialog($scope, aData, 0, 'account', buttonset(['save','cancel']), false);
    }
    
    
    ipymeajax('/shop/user/get', {})
    .success(function(responseData){
        $scope.model.user_details = responseData.user_details;
        $scope.model.user_details.addresses[0] && ($scope.model.user_details.country_selected = $scope.model.user_details.addresses[0].country_c_code);
        $scope.model.user_details.address_selected = ($scope.model.user_details.addresses.length > 0) ? $scope.model.user_details.addresses[0] : {};
        $scope.model.user_details.address_delivery = $scope.model.user_details.addresses[0];
        $scope.model.user_details.people_selected = ($scope.model.user_details.people.length>0) ? $scope.model.user_details.people[0]:{};
        $scope.model.user_details.card_selected = $scope.model.user_details.card[0];
        $scope.model.card_vendors = {available : responseData.user_details.card_vendor};
    });
}])

.controller('productController', ['$scope','$location','ipymeajax','$routeParams','imageSourceHost', function ($scope, $location,ipymeajax,$routeParams,imageSourceHost) {
    $scope.model = {imageSourceHost:imageSourceHost,product:{}, basket:{}}
    ipymeajax('/shop/product/get/'+$routeParams.id, {})
    .success(function(responseData){
        $scope.model.product = responseData.product;
        $scope.model.product.quantity = 1;
    });
    
    $scope.redirect = function(path) {
        $location.path(path);
    }
    
    $scope.addbutton = function(product) {
        var bInBasket = false, p = $scope.model.basket.products;
        for(var i in p){
            if (p[i].bl_product == product.p_id) {
                p[i].bl_quantity = parseFloat(p[i].bl_quantity)+product.quantity;
                bInBasket = true;
                break;
            }
        }
        
        bInBasket || $scope.model.basket.products.push({bl_product:product.p_id
                                                        , p_description:product.p_description
                                                        , bl_quantity:product.quantity
                                                        , p_price:product.p_price
                                                        , c_name:product.c_name});
    }
    
    $scope.basketpersist = function(initialize){
        $scope.basketpersist.basketWaitingUpdate = true;
        if (initialize){
            ipymeajax('/shop/basket/get', {})
            .success(function(responseData){
                if (responseData.valid_session != 0) {
                    $scope.model.basket.id          = responseData.basket.id;
                    $scope.model.basket.products    = responseData.basket.products;
                    $scope.model.basket.initialized = true;
                }
                $scope.basketpersist.basketWaitingUpdate = false;
            });
        }
        else {
            ipymeajax('/shop/basket/save', $scope.model.basket)
            .success(function(responseData){
                if (responseData.valid_session != 0) {
                    $scope.model.basket.id = responseData.basket.id;
                }
                $scope.basketpersist.basketWaitingUpdate = false;
            });
        }
    }
 
}])
.controller('ShopMenuController',['$scope',"ipymeajax", function ($scope,ipymeajax) {
    ipymeajax('/shop/menu/shop', {})
    .success(function(responseData){
        $scope.menutree = responseData;
    });
}])
.controller('logoutCtrl',['$location', function ($location) {
    $location.path('/shop');
}])
.controller('UserController',['$scope','$location', '$dialog','ipymeajax','buttonset','opendialog', function ($scope,$location,$dialog,ipymeajax,buttonset,opendialog) {
    var select2CountryFormat=function(state) {
                                    if (!state) return;
                                    if (!state.id) return state.text; // optgroup
                                    return '<img class="flag flag-'+state.id+'"/>'+state.text;
                                }
                                
    $scope.$watch('model.panes', function(panes){
        if (panes.filter(function(tab){return tab.active})[0].title=='Orders'){
            var gridOptions = $scope.model.orders.ordersGridOptions;
            setTimeout(function(){gridOptions.$gridServices.DomUtilityService.RebuildGrid(gridOptions.$gridScope,gridOptions.ngGrid)},1);
        }
    },true);
    
    $scope.model = {panes:[{ title:"Account", template:'paneaccount', active:true },
                            { title:"Address", template:"paneaddress" },
                            { title:"Payments", template:"panepayments"},
                            { title:"Orders", template:"paneorders"},],
                    countries:{available:[],
                                selected:null,
                                selectcountryoptions:{allowClear: true, 
                                                        placeholder: "Select country",
                                                        formatResult: select2CountryFormat,
                                                        formatSelection: select2CountryFormat,
                                                        escapeMarkup: function(m) { return m; },},},
                    card_vendors:{available:[],
                                   selected:null,
                                   selectcardoptions:{allowClear: false, 
                                                        placeholder: "Select vendor"},},
                    titles:['Mr.','Mrs.','Ms.'],
                    orders:{columnDefs:[{field : "u_id", displayName : "ID", width : 50},
                                        {field : "u_session", displayName : "Session", width : 250},
                                        {field : "u_basket", displayName : "Basket", width : 70}],
                             data: [{u_id:'ddd'
                                    ,u_session:'ddd'
                                    ,u_basket:'ddd'},
                                    {u_id:'ddd'
                                    ,u_session:'ddd'
                                    ,u_basket:'ddd'}],                           
                             ordersGridOptions:{enableColumnResize:true,
                                                  enableColumnReordering:true,
                                                  multiSelect:false,
//                                                  jqueryUITheme:true,
                                                  showFilter:true,
                                                  showFooter:true,
                                                  enablePaging:true,
                                                  enableRowSelection: true,
                                                   showSelectionCheckbox: true,
                                                  pagingOptions:{ pageSizes: [5, 10, 20], pageSize: 10, totalServerItems: 0, currentPage: 1 },
                                                  columnDefs:'model.orders.columnDefs',
                                                  data: 'model.orders.data',
                                                  selectedItems: [],},},
                    user_details:{},
    }
            
    ipymeajax('/shop/user/getCountries', {})
    .success(function(responseData){
        $scope.model.countries.available = responseData.available;
    });
    
    
    ipymeajax('/shop/user/get', {})
    .success(function(responseData){
        $scope.model.user_details = responseData.user_details;
        $scope.model.user_details.addresses[0] && ($scope.model.user_details.country_selected = $scope.model.user_details.addresses[0].country_c_code);
        $scope.model.user_details.address_selected = $scope.model.user_details.addresses[0];
        $scope.model.user_details.card_selected = $scope.model.user_details.card[0];
        $scope.model.user_details.people_selected = ($scope.model.user_details.people.length>0) ? $scope.model.user_details.people[0]:{};
        $scope.model.card_vendors.available = responseData.user_details.card_vendor;
    });
    
    $scope.addAddress = function() {
        var aData = {countries:$scope.model.countries,
                    fields:{ address_detail_ad_country:{country_c_code: "gb"}}};
        opendialog($scope, aData,1, 'address', buttonset(['save','cancel']), false);
    }
    
    $scope.addPayment = function() {
        var aData = {card_vendors:$scope.model.card_vendors,
                    fields:{}};
        opendialog($scope, aData,1, 'card', buttonset(['save','cancel']), false);
    }
    
    
    $scope.editPayment = function() {
        var aData = {card_vendors:$scope.model.card_vendors,
                    fields:$scope.model.user_details.card_selected};
        opendialog($scope, aData, 0, 'card', buttonset(['save','cancel']), false);
    }
    
    
    $scope.editAddress = function() {
         var aData = {countries:$scope.model.countries,
                    fields:$scope.model.user_details.address_selected};
        opendialog($scope, aData, 0, 'address', buttonset(['save','cancel']), false);
    }
    
    $scope.editAccount = function() {
         var aData = {titles:$scope.model.titles,
                    fields:$scope.model.user_details.people_selected};
        opendialog($scope, aData, 0, 'account', buttonset(['save','cancel']), false);
    }
     
}])
;
