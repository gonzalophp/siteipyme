<div class="ipymeshop" ng-controller="ShopController">
    <loading ng-model="model.loading"></loading>
    <shoptopbar></shoptopbar>
    <div ng-show="model.loading.complete" class="ipymeshopbody" >
        <div class="carousel" ng-controller="CarouselItemsCtrl">
            <carousel interval="100000">
                <slide ng-repeat="slide in slides" active="slide.active">
                    <div class="carousel-content">
                        <table>
                            <tbody>
                                <tr>
                                    <td>
                                        <a href="#/shop/product/{{slide.id}}"><img ng-src="{{slide.image}}" style="margin:auto;"></a>
                                    </td>
                                    <td>
                                        <div class="carousel-details">
                                            <a href="#/shop/product/{{slide.id}}">
                                                <p>{{slide.description}}</p>
                                            </a>
                                            <p>{{slide.longdescription}}</p>
                                            <p>{{slide.price}}</p>
                                        </div>
                                    </td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                </slide>
            </carousel>
        </div>
        <categorymenu menutree="menutree" menuclick="menuclick" get-li-class="getLiClass" class="shopmenu"></categorymenu>
        <div class="ipymeshopcolumns">
            <table>
                <tbody>
                    <tr>
                        <td>
                            <div ng-show="model.relativeAttributes" class="ipymeshopleft">
                                <ul ng-repeat="attributeDetails in model.relativeAttributes">
                                    <li >
                                        <p class="ipymeTitle">{{attributeDetails.pca_attribute}}</p>
                                        <ul>
                                            <relatedattribute ng-click="attributevalueclick" modelattribute="attribute" ng-repeat="attribute in attributeDetails.attributes"></relatedattribute>
                                        </ul>
                                    </li>
                                </ul>
                            </div>
                        </td>
                        <td>
                            <div class="ipymeshopcenter">
                                <div ng-show="waitingUpdate" class="ajax-waiting"></div>
                                <ul ng-repeat="product in model.displayedProducts">
                                    <li>
                                        <displayproduct ng-model="product" ng-addbutton="addToBasket"></displayproduct>
                                    </li>
                                </ul>
                            </div>
                        </td>
                        <td class="basket">
                            <basket class="ipymeshopright" persist="basketpersist" ng-model="model.basket"></basket> 
                        </td>
                    </tr>
                </tbody>
            </table>
        </div>
    </div>
    <footer>
        <p>2013 - Gonzalo Grado </p>
    </footer>
</div>