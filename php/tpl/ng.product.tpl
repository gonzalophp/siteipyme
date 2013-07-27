<div class="ipymeshop">
    <div class="ipymeshopbody" ng-controller="productController">
        <div class="ipymeproduct">
            <table>
                <tr>
                    <td>
                        <div>
                            <p>{{model.product.p_category_name}}</p>
                            <p>{{model.product.p_ref}}</p>
                            <p><img ng-src="{{model.imageSourceHost}}{{model.product.p_image_path}}"/></p>
                            <p>{{model.product.p_description}}</p>
                            <p>{{model.product.p_long_description}}</p>
                            <p>{{model.product.c_name}}&nbsp;{{model.product.p_price}}</p>
                            <div class="ipymeButtonsGroup">
                                <button class="shop" ng-click="redirect('/shop')">Continue Shopping</button>
                                <button class="shop addtobasket" ng-click="addbutton(model.product)">Add to Basket</button>
                                <quantity class="basketquantity" ng-model="model.product.quantity"></quantity>
                            </div>
                        </div>
                    </td>
                    <td class="basket">
                        <basket class="ipymeshopright" persist="basketpersist" ng-model="model.basket"></basket> 
                    </td>
                </tr>
            </table>
        </div>
    </div>
</div>