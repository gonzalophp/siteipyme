<main-menu class="adminmenu" ng-controller="MainMenuController"></main-menu>
<div class="container">
    <div class="ipymeCategory" ng-controller="categorytreeeditcontroller">
        <table>
            <tbody>
                <tr>
                    <td>
                        <div class="ipymeTreeCategories">
                            <p class="ipymeTitle">Category</p>
                            <div id="categorytree" spectralbutton="newCategory" spectralbuttontext="New"></div>
                        </div>
                    </td>
                    <td>
                        <div class="ipymeAttributes">
                            <p class="ipymeTitle">Attributes</p>
                            <div class="attributelist" spectralbutton="addAttribute" spectralbuttontext="Add" ng-transclude>
                                <ipymeedit edited="editedAttribute" remove="removeAttribute" values="model.current_node.attributes.values" ng-repeat="categoryattribute in model.current_node.attributes.values"></ipymeedit>
                            </div>
                        </div>
                    </td>
                </tr>
                <tr>
                    <td colspan="2">
                        <button class="ipymeButton" ng-click="saveCategories()">Save</button>
                    </td>
                </tr>
            </tbody>
        </table>
    </div>
</div>