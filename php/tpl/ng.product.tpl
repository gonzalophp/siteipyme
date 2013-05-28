<link rel="stylesheet" href="css/shop.css"/>
<div class="ipymeshop">
    <div class="ipymeshopbody" ng-controller="basketCtrl">
        <div class="product" ng-controller="productController">
            <p>{{model.product.p_category_name}}</p>
            <p>{{model.product.p_ref}}</p>
            <p><img src="{{model.product.p_image_path}}"/></p>
            <p>{{model.product.p_description}}</p>
            <p>{{model.product.p_long_description}}</p>
            <p>{{model.product.p_price}}</p>
            <div class="ipymeButtonsGroup">
                <button class="shop" ng-click="redirect('/shop')">Continue Shopping</button>
                <button class="shop addtobasket" ng-click="addbutton(model.product)">Add to Basket</button>
            </div>
        </div>
    </div>
</div>