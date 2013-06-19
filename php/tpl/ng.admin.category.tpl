<main-menu class="adminmenu" ng-controller="MainMenuController"></main-menu>
<div class="container">
    <div class="ipymeCategory" ng-controller="categorytreeeditcontroller">
        <table>
            <tbody>
                <tr>
                    <td>
                        <div class="ipymeTreeCategories">
                            <p class="ipymeTitle">Category</p>
                            <div class="ipymeButtonsGroup">
                                <button class="ipymeButton" ng-click="newCategory()">New</button>
                            </div>
                            <div id="categorytree"></div>
                        </div>
                    </td>
                    <td>
                        <div class="ipymeAttributes">
                            <p class="ipymeTitle">Attributes</p>
                            <div class="ipymeButtonsGroup">
                                <button class="ipymeButton" ng-click="addAttribute()">Add</button>
                            </div>
                            <div class="attributelist">
                                <ipymeedit edited="editedAttribute" remove="removeAttribute" values="model.current_node.attributes.values" ng-repeat="categoryattribute in model.current_node.attributes.values"></ipymeedit>
                            </div>
                        </div>
                    </td>
                </tr>
                <tr>
                    <td colspan="2">
                        <button class="ipymeButton" ng-click="getTreeValues()">Refresh</button>
                        <button class="ipymeButton" ng-click="saveCategories()">Save</button>
                    </td>
                </tr>
            </tbody>
        </table>
    </div>
</div>