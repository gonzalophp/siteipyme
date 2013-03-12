function loadScript(url, callback) {
   var head = document.getElementsByTagName('head')[0];
   var script = document.createElement('script');
   script.type = 'text/javascript';
   script.src = url;

   script.onreadystatechange = callback;
   script.onload = callback;

   head.appendChild(script);
}

function ArrayExtra(a){
    var that = (!a) ? new Array():a;
    
    that.unique = function() {
        var o = {}, i, r = new ArrayExtra();
        for(i=this.length-1; i>=0; o[this[i]] = this[i--]);
        for(i in o) r.push(o[i]);
        return r;
    }

    that.diff = function(aArrayB) {
        // ThisArray - ArrayB
        var o = {}, i, r = new ArrayExtra();
        for(i=aArrayB.length-1; i>=0; o[aArrayB[i]] = aArrayB[i--]);
        for(i=this.length-1; i>=0; ((!o[this[i]])?r.push(this[i--]):i--)); 
        return r;
    }
    
    return that;
}

function SVGElementExtra(oElement){
    var that = oElement;
    that.setAttributes = function(aAttributes){
        for(var i=0;i<aAttributes.length;i++){
            // attrName:attrValue
            var attr = aAttributes[i].split('=', 2);
            this.setAttribute(attr[0], attr[1]);
        }
    }
    return that;
}

function getPopup(oSudokuCell){
    var that = new SVGElementExtra(document.createElementNS(oSudokuCell.oSudoku.namespace,"g"))
        that.oSudokuCell = oSudokuCell;
    
    that.close = function(){
        if (that.oSudokuCell.oSudoku.popup){
            if (that.oSudokuCell.oSudoku.popup['popup']){
                clearTimeout(that.oSudokuCell.oSudoku.popup['timeout']);
                that.oSudokuCell.oSudoku.removeChild(that.oSudokuCell.oSudoku.popup['popup']);
                that.oSudokuCell.oSudoku.popup['popup'] = null;
            }
        }
    }
    
    that.close();
    
    var offsetX = 3*Math.floor((that.oSudokuCell.i-1)/3),
        offsetY = 3*Math.floor((that.oSudokuCell.j-1)/3),
        aTakenNumbers = new ArrayExtra(),
        aAvailableNumbers = new ArrayExtra([1,2,3,4,5,6,7,8,9]),
        i, j;

    for(j=1;j<10;j++) aTakenNumbers.push(that.oSudokuCell.oSudoku.oSudokuData[that.oSudokuCell.i][j].current);
    for(i=1;i<10;i++) aTakenNumbers.push(that.oSudokuCell.oSudoku.oSudokuData[i][that.oSudokuCell.j].current);
    for(i=1;i<4;i++){
        for(j=1;j<4;j++){
            aTakenNumbers.push(that.oSudokuCell.oSudoku.oSudokuData[offsetX+i][offsetY+j].current);
        }
    }
    aTakenNumbers = aTakenNumbers.unique();
    aAvailableNumbers = aAvailableNumbers.diff(aTakenNumbers.unique());
    that.aAvailableNumbers = aAvailableNumbers;
    if (aAvailableNumbers.length>0){
        
        that.setAttribute('id', 'sudoku_popup');

        SVGGElement.prototype.sudokuData = that.oSudokuCell.oSudoku.oSudokuData;
        for(i=0;i<aAvailableNumbers.length;i++){
            var oCellGroup = new SVGElementExtra(document.createElementNS(that.oSudokuCell.oSudoku.namespace,"g"));
            oCellGroup.setAttributes(["cursor=pointer"]);    
            oCellGroup.nNumber = aAvailableNumbers[i];
            oCellGroup.oCell = new SVGElementExtra(document.createElementNS(that.oSudokuCell.oSudoku.namespace,"rect"));
            oCellGroup.oText = new SVGElementExtra(document.createElementNS(that.oSudokuCell.oSudoku.namespace,"text"));
            oCellGroup.oTextNode = document.createTextNode(oCellGroup.nNumber);

            oCellGroup.oCell.setAttributes(["x=30","y="+(40+(i*30)), "height=30", "width=50", "fill=blue", "stroke=white"]);
            oCellGroup.oText.setAttributes(["x=48","y="+(65+i*30),  "stroke=white", "fill=white","font-family=verdana 14px", "font-size=30px"]);

            oCellGroup.onclick = function(e){
                that.oSudokuCell.oText.textContent = this.nNumber;
                that.oSudokuCell.oSudoku.oSudokuData[that.oSudokuCell.i][that.oSudokuCell.j].current = this.nNumber;
                that.oSudokuCell.oCell.setAttributes(["fill=red"]);
                that.close();
            }

            oCellGroup.onmouseover = function(e){
                this.oCell.setAttributes(["fill=red"]);
                clearTimeout(that.oSudokuCell.oSudoku.popup['timeout']);
            }

            oCellGroup.onmouseout = function(e){
                this.oCell.setAttributes(["fill=blue"]);
                that.oSudokuCell.oSudoku.popup = {'timeout':setTimeout(that.close, 500), 'popup':that};
            }
            oCellGroup.oText.appendChild(oCellGroup.oTextNode);

            oCellGroup.appendChild(oCellGroup.oCell);
            oCellGroup.appendChild(oCellGroup.oText);
            that.appendChild(oCellGroup);
        }

        var oCell = new SVGElementExtra(document.createElementNS(that.oSudokuCell.oSudoku.namespace,"rect"));
        oCell.setAttributes(["x=29","y=39", "width=52","height="+(2+(aAvailableNumbers.length*30)), "fill=none", "stroke=rgb(255,190,0)", "stroke-width=3", "rx=5", "ry=5"]);
        that.appendChild(oCell);
        that.oSudokuCell.oSudoku.popup = {'timeout':setTimeout(that.close, 2000), 'popup':that};
        that.oSudokuCell.oSudoku.appendChild(that);
    }
    
    return that;
}
    

function SudokuCell(oSudoku, oSudokuData){
    var that = new SVGElementExtra(document.createElementNS(oSudoku.namespace,"g"))
        that.i = oSudokuData.i,
        that.j = oSudokuData.j,
        that.oSudoku = oSudoku,
        cellLength = 45;
    
    that.oCell = new SVGElementExtra(document.createElementNS(oSudoku.namespace,"rect")),
    that.oText = new SVGElementExtra(document.createElementNS(oSudoku.namespace,"text"));
    that.oTextNode = document.createTextNode('');
    that.appendChild(that.oCell);
    that.appendChild(that.oText);
    that.oText.appendChild(that.oTextNode);
    
    that.oCell.setAttributes(["x="+(cellLength*that.i),"y="+(cellLength*that.j), "width="+(cellLength-4), "height="+(cellLength-4), "fill=rgb(200,200,200)" ]);
    that.oText.setAttributes(["x="+(13+cellLength*that.i),"y="+(32+cellLength*that.j), "textlength=12", "stroke=black", "font-family=verdana", "font-size=26px", "cursor=default"]);
    
    if (oSudokuData.current){
        that.oTextNode.textContent = oSudokuData.current;
    }
    else {
        that.setAttributes(["cursor=pointer"]);
        that.onclick = function(e){
            var oPopup = new getPopup(this);
            if (oPopup.aAvailableNumbers.length > 0){
                this.oSudoku.appendChild(oPopup);
            }
        }
    }
    
    return that;
}    
        

function Sudoku(data, hidePercentage){
    var namespace="http://www.w3.org/2000/svg",
        that = new SVGElementExtra(document.createElementNS(namespace,"svg")),
        oPath,
        oAttr,
        i,j;
    that.namespace=namespace,
    that.version="1,1",
    that.oSudokuData=[],
    that.setAttributes(["width=500","height=500"]);
        
    oAttr = document.createAttributeNS(namespace,"xmlsn");
    oAttr.value = namespace;
    that.setAttributeNodeNS(oAttr);
    oAttr = document.createAttributeNS(namespace,"version");
    oAttr.value = that.version;
    that.setAttributeNodeNS(oAttr);
    
    that.getElement= function(tag){
        return document.createElementNS(this.namespace,tag);
    }
    
    for(j=1;j<10;j++){
        for(i=1;i<10;i++){
            if (!that.oSudokuData[i]){
                that.oSudokuData[i]=[];
            }

            that.oSudokuData[i][j] = {'i':i, 'j':j, 'correct': data[i][j], 'current':null}

            if ((Math.floor(100*Math.random())) > hidePercentage) {
                that.oSudokuData[i][j].current = data[i][j];
            }
            

            that.oSudokuData[i][j].oSudokuCell = new SudokuCell(that, that.oSudokuData[i][j]);
            that.appendChild(that.oSudokuData[i][j].oSudokuCell);
        }
    }
    oPath = new SVGElementExtra(document.createElementNS(namespace,"path"));
    oPath.setAttributes(["d=M43 43 L43 447 L447 447 L447 43 L41 43 M178 43 L178 447 M313 43 L313 447 M43 178 L447 178 M43 313 L447 313","stroke=black","stroke-width=4", "fill=none"]);
    that.appendChild(oPath);
    $('div#sudoku').append(that);
    
    return that;
}

function initSudoku() {
    if (document.sudokuInit++ == 0){
        var xmlhttp=new XMLHttpRequest();
        xmlhttp.open("POST", "sudoku.php", true);
        xmlhttp.setRequestHeader("Content-type","application/x-www-form-urlencoded");
        xmlhttp.onreadystatechange=function() {
            if (xmlhttp.readyState==4) Sudoku(JSON.parse(xmlhttp.responseText), 60);
        }
        xmlhttp.send("");    
    }
}


document.sudokuInit = 0; // Init status
loadScript("js/jquery-1.9.0.min.js",initSudoku);