var ApplicationValues = {element_color: "#ffffbb",dialog: new Dialog()};
var active_el = null;
var Application = function(a) {
    a = a || {};
    if (!(a.id && a.width && a.height)) {
        return
    }
    this._width = a.width;
    this._height = a.height;
    this._generateStructure(a.id);
    this.setProfileGenericMenu();
    this._generateGeneralMenu();
    this._selected = null;
    this._diagrams = [];
    this._tabs = []
    if(gon.scenario!=null){
    this.setXMLString(gon.scenario);
    }
};
var _acceptedDiagrams = [];
var _acceptedElementsUML = [];
var _genericMenu = [];
var _specificMenu = [];
var _stereotypes = [];
var _metaclass = [];
var _delProfileElement = function(b) {
    if (b.getType() == "UMLMetaclass") {
        for (var a in _metaclass) {
            if (_metaclass[a] == b) {
                _metaclass.splice(a, 1)
            }
        }
    }
    if (b.getType() == "UMLStereotype") {
        for (var a in _stereotypes) {
            if (_stereotypes[a] == b) {
                _stereotypes.splice(a, 1)
            }
        }
    }
};
Application.prototype._generateStructure = function(b) {
    var g = document.getElementById(b);
    var d = document.createElement("div");
    d.setAttribute("id", "ud_tools_div");
    var f = document.createElement("ul");
    f.setAttribute("id", "ud_tools_ul1");
    var e = document.createElement("ul");
    e.setAttribute("id", "ud_tools_ul2");
    d.appendChild(f);
    d.appendChild(e);
    g.appendChild(d);
    this._tools_div = d;
    this._tools_ul1 = f;
    this._tools_ul2 = e;
    var l = document.createElement("div");
    l.setAttribute("id", "ud_container_div");
    var alert = document.createElement("div");
    alert.setAttribute("id","alert_div");
    l.appendChild(alert);
    var n = document.createElement("div");
    n.setAttribute("id", "ud_selector_div");
    n.style.width=this._width + "px";
    var a = document.createElement("ul");
    a.setAttribute("id", "ud_selector_ul");
    n.appendChild(a);
    l.appendChild(n);
    this._selector_ul = a;
    var j = document.createElement("div");
    j.setAttribute("id", "ud_diagram_div");
    j.setAttribute("class", "ud_diagram_div");
    j.style.width = this._width + "px";
    j.style.height = this._height + "px";
    this._diagram_div = j;
    l.appendChild(j);
    g.appendChild(l);
    var c;
    c = document.createElement("canvas");
    c.setAttribute("class", "ud_diagram_canvas");
    c.width = this._width;
    c.height = this._height;
    j.appendChild(c);
    this._mainContext = c.getContext("2d");
    this._mainCanvas = c;
    c = document.createElement("canvas");
    c.setAttribute("class", "ud_diagram_canvas");
    c.width = this._width;
    c.height = this._height;
    c.onmousedown = function() {
        return false
    };
    j.appendChild(c);
    this._motionContext = c.getContext("2d");
    var h = document.createElement("div");
    h.setAttribute("id", "ud_update_div");
    h.title = "apply changes in profile to diagrams";
    h.style.right = 15 + "px";
    h.style.display = "none";
    j.appendChild(h);
    var k = this;
    h.onclick = function() {
        ApplicationValues.dialog._text = "Do you want to update the diagrams according to the changes of the profile?";
        ApplicationValues.dialog._cancelable = true;
        if (k._selected && k._diagrams[k._selected].getType() == "UMLProfile") {
            ApplicationValues.dialog.show(function() {
                var o = [];
                for (i in k._diagrams) {
                    if (k._diagrams[i].getType() != "UMLProfile") {
                        o.push(k._diagrams[i])
                    }
                }
                k._diagrams[k._selected].updateProfile(o)
            })
        }
    };
    var m = document.createElement("div");
    m.setAttribute("id", "ud_delete_div");
    b = document.createElement("img");
    b.setAttribute("src", "/assets/delete_button.png");
    m.appendChild(b);
    j.appendChild(m);
    var k = this;
    m.onclick = function() {
        ApplicationValues.dialog._text = 'Do you want to delete the diagram "' + k._diagrams[k._selected].getName() + '"?';
        ApplicationValues.dialog._cancelable = true;
        if (k._selected) {
            ApplicationValues.dialog.show(function() {
                k._delDiagram();
                k._generateSpecificMenu()
            })
        }
    }
};
Application.prototype._changeTabName = function(c) {
    var e = this._diagrams[c].getName();
    if (e.length > 20) {
        e = e.substring(0, 17);
        e += "..."
    }
    var b = this._tabs[c];
    var d = b.firstChild;
    var a = d.firstChild;
    d.removeChild(a);
    d.appendChild(document.createTextNode(e))
};
Application.prototype._addTab = function(b) {
    var a = document.createElement("li");
    var d = document.createElement("a");
    d.appendChild(document.createTextNode(""));
    a.appendChild(d);
    this._selector_ul.appendChild(a);
    this._tabs[b] = a;
    var c = this;
    a.onclick = function() {
        if (c._selected == b) {
            ApplicationValues.dialog._text = "Diagram name:";
            ApplicationValues.dialog._cancelable = true;
            var e = c._diagrams[b];
            ApplicationValues.dialog.show(function(f) {
                if (f == "") {
                    f = "Untitle"
                }
                e.setName(f);
                c._changeTabName(b);
                e.draw()
            }, e.getName())
        } else {
            c._selectDiagram(b)
        }
    };
    this._changeTabName(b)
};
Application.prototype._delTab = function(a) {
    this._selector_ul.removeChild(this._tabs[a]);
    delete this._tabs[a]
};
Application.prototype._generateIndex = function() {
    var a = Math.random();
    while (true) {
        if (a in this._diagrams) {
            a = Math.random()
        } else {
            return a
        }
    }
};
Application.prototype.addDiagram = function(a) {
    var b = this._generateIndex();
    a.initialize(b, this._diagram_div, this._mainContext, this._motionContext, this._width, this._height);
    this._diagrams[b] = a;
    this._diagrams[b].setUpdateHeightCanvas(true);
    if (a.isVisible()) {
        this._addTab(b)
    }
    this._selectDiagram(b)
};
Application.prototype._delDiagram = function() {
    var a = this._selected;
    if (a) {
        this._diagrams[a].interaction(false);
        this._delTab(a);
        if (this._diagrams[a].getType() == "UMLProfile") {
            var c = [];
            for (b in this._diagrams) {
                if (this._diagrams[b].getType() != "UMLProfile") {
                    c.push(this._diagrams[b])
                }
            }
            this._diagrams[a].removeProfile(c);
            for (b = 0; b < this._diagrams[a]._nodes.length; b++) {
                _delProfileElement(this._diagrams[a]._nodes[b])
            }
        }
        delete this._diagrams[a];
        this._selected = null;
        var b;
        for (b in this._diagrams) {
            if (this._diagrams[b]._visible) {
                this._selectDiagram(b);
                return
            }
        }
        this._clearCanvas()
    }
};
Application.prototype._clearCanvas = function() {
    this._mainContext.clearRect(0, 0, this._width, this._height);
    this._motionContext.clearRect(0, 0, this._width, this._height)
};
Application.prototype._selectDiagram = function(b) {
    if (this._selected && this._diagrams[b].isVisible()) {
        this._diagrams[this._selected].interaction(false);
        this._tabs[this._selected].removeAttribute("class");
        this._diagrams[this._selected].deselect()
    }
    this._clearCanvas();
    this._diagrams[b].draw();
    this._diagrams[b].interaction(true);
    if (this._diagrams[b].isVisible()) {
        this._selected = b;
        this._diagrams[b].select();
        this._tabs[b].setAttribute("class", "active");
        this._generateSpecificMenu();
        var a = document.getElementById("ud_update_div");
        if (this._diagrams[b].getType() == "UMLProfile") {
            a.style.display = "block"
        } else {
            a.style.display = "none"
        }
    }
};
Application.prototype._getDiagramImage = function() {
    if (this._selected) {
        this._diagrams[this._selected].stopEvents();
        this._diagrams[this._selected].draw();
        return this._mainCanvas.toDataURL("image/png")
    }
};

Application.prototype._generateGeneralMenu = function() {
    var e = this;
    var g = this._tools_div;
    var c = document.createElement("h4");
    var f = document.createTextNode("Actions");
    var b = document.createElement("img");
    b.setAttribute("src", "/assets/vertical_flow.png");
    c.appendChild(b);
    c.appendChild(f);
    g.insertBefore(c, this._tools_ul1);
    c.onclick = function() {
        var j = document.getElementById("ud_tools_ul1");
        var h;
        if (j.style.display == "none") {
            j.style.display = "block";
            this.childNodes[0].setAttribute("src", "/assets/vertical_flow.png")
        } else {
            j.style.display = "none";
            this.childNodes[0].setAttribute("src", "/assets/horizontal_flow.png")
        }
    };
      
    this._addSubmit(this._tools_ul1, "Export xml", function(m) {
        var p = this;
        this._active = true;
        var h = document.createElement("div");
        document.getElementById("umldiagram").appendChild(h);
        var j = document.createElement("form");
        var k = document.createElement("input");
        var q = document.createElement("input");
        j.setAttribute("accept-charset","UTF-8");
        j.setAttribute("action","/generate_scenario");
        j.setAttribute("enctype","multipart/form-data");
        j.setAttribute("data-remote","true");
        j.setAttribute("method","post");
        j.setAttribute("id","frm1")
        k.setAttribute("id", "xml");
        k.setAttribute("name", "xml");
        k.setAttribute("type", "hidden");
        q.setAttribute("type", "submit");
        q.setAttribute("value", "Save");
        q.setAttribute("name", "commit");
        q.setAttribute("class","custom_better_button righty submittable");
        var r = function(v) {
            k.value = m.getXMLString();
            
            k.select()
        };
        var l = function(v) {
            k.value = m.getXMLString();
            k.select()
        };
        var o = function(v) {
            document.body.removeChild(h)
        };
        j.onsubmit = function() {
            return false
        };
        q.addEventListener("click", r, false);
        j.appendChild(k);
        j.appendChild(q);
        document.getElementById('ud_container_div').insertBefore(j,document.getElementById('ud_selector_div'));
        k.focus();
        h.style.top = (window.innerHeight - j.offsetHeight) / 2+ "px";
        h.style.left = (window.innerWidth - j.offsetWidth) / 2 + "px"
    }, 0, "import_export");
    
    //Import only
    this._addMenuItem(this._tools_ul1, "Import from XML", function(m) {
        var p = this;
        this._active = true;
        var h = document.createElement("div");
        var j = document.createElement("form");
        var k = document.createElement("input");
        var u = document.createElement("input");
        k.setAttribute("id", "xml");
        k.setAttribute("name", "xml");
        k.setAttribute("type", "text");
        u.setAttribute("type", "submit");
        u.setAttribute("value", "Import");
        var n = function(v) {
            m.setXMLString(k.value);
            document.body.removeChild(h)
            k.select()
        };
        var o = function(v) {
            document.body.removeChild(h)
        };
        j.onsubmit = function() {
            return false
        };
        u.addEventListener("click", n, false);
        j.appendChild(k);
        j.appendChild(u);
        h.appendChild(j);
        document.body.appendChild(h);
        k.focus();
        h.style.top = (window.innerHeight - parseInt(h.offsetHeight+100)) / 2 + "px";
        h.style.left = (window.innerWidth) / 2 + "px"
        h.setAttribute("class","ud_popupColor")
        var K = document.createElement("input");
        K.setAttribute("type", "submit");
        K.setAttribute("value", "ok");
        var H = document.createElement("input");
        H.setAttribute("type", "submit");
        H.setAttribute("value", "cancel");
        h.appendChild(K);
        h.appendChild(H);
        var cancel = function() {
            document.body.removeChild(h)
        };
        H.addEventListener("click", cancel, false);
        K.addEventListener("click", n, false);
    }, 0, "import_export");

    this._addMenuItem(this._tools_ul1, "Generate image (png)", function(k, j) {
        if (k._selected) {
            var h = window.open(k._getDiagramImage(), "diagramImage", "height=" + (k._height + 70) + ",width=" + (k._width + 20));
            h.focus()
        } else {
            alert("You did not select any diagram")
        }
    }, 0, "generate_image");
    this._addMenuItem(this._tools_ul1, "Delete object", function(l, h, p) {
        var n = l.getElementByPoint(h, p);
        if (n) {
            var o = false;
            var m = "";
            for (var j = 0; j < n._components.length && !o; j++) {
                if (n._components[j].getId() == "name") {
                    m = n._components[j]._text;
                    o = true
                }
            }
            if (m != "") {
                m = ' "' + m + '" '
            }
            ApplicationValues.dialog._text = "Do you want to delete the object" + m + " (" + n.getType() + ") ?";
            ApplicationValues.dialog._cancelable = true
        }
        if (n != null && n instanceof Element) {
            ApplicationValues.dialog.show(function() {
                l.delElement(n);
                l.draw();
                _delProfileElement(n)
            })
        }
    }, 1, "delete_object");
    this._addMenuItem(this._tools_ul1, "Modify color", function(x) {
        var r = ApplicationValues.element_color;
        var z = ApplicationValues.element_color.split("#")[1];
        var C = new Array(parseInt(z.slice(0, 2), 16), parseInt(z.slice(2, 4), 16), parseInt(z.slice(4, 6), 16));
        var A = document.createElement("div");
        A.className = "ud_popupColor";
        var J = document.createElement("div");
        J.setAttribute("id", "divBlock1");
        var I = document.createElement("div");
        I.setAttribute("id", "divBlock2");
        var n = document.createElement("div");
        n.setAttribute("id", "colorHtml");
        n.style.color = "#ffffff";
        var h = document.createElement("div");
        h.setAttribute("id", "red");
        var y = document.createElement("canvas");
        y.setAttribute("id", "R");
        y.width = 150;
        y.height = 20;
        h.appendChild(y);
        var j = y.getContext("2d");
        var s = document.createElement("div");
        s.setAttribute("id", "green");
        var B = document.createElement("canvas");
        B.setAttribute("id", "G");
        B.width = 150;
        B.height = 20;
        s.appendChild(B);
        var t = B.getContext("2d");
        var v = document.createElement("div");
        v.setAttribute("id", "blue");
        var D = document.createElement("canvas");
        D.setAttribute("id", "B");
        D.width = 150;
        D.height = 20;
        v.appendChild(D);
        var w = D.getContext("2d");
        var u = document.createElement("div");
        u.setAttribute("id", "divSelectColor");
        var G = document.createElement("canvas");
        G.setAttribute("id", "selectColor");
        G.width = 90;
        G.height = 90;
        u.appendChild(G);
        var l = G.getContext("2d");
        var m = document.createElement("form");
        var K = document.createElement("input");
        K.setAttribute("type", "submit");
        K.setAttribute("value", "ok");
        var H = document.createElement("input");
        H.setAttribute("type", "submit");
        H.setAttribute("value", "cancel");
        var F = function(L) {
            document.body.removeChild(A)
        };
        var q = function(L) {
            ApplicationValues.element_color = r;
            document.body.removeChild(A)
        };
        K.addEventListener("click", F, false);
        H.addEventListener("click", q, false);
        m.onsubmit = function() {
            return false
        };
        K.focus();
        m.appendChild(K);
        m.appendChild(H);
        J.appendChild(n);
        J.appendChild(h);
        J.appendChild(s);
        J.appendChild(v);
        J.appendChild(m);
        A.appendChild(J);
        I.appendChild(u);
        I.appendChild(document.createElement("div"));
        A.appendChild(I);
        var E = function(N, M, O, L) {
            if (O == 0) {
                O = 0.1
            } else {
                if (O == 120) {
                    O = 119.9
                }
            }
            M.save();
            M.font = "12px monospace";
            M.textBaseline = "middle";
            M.fillStyle = "#ffffff";
            M.fillText(N.getAttribute("id"), 0, N.height / 2);
            M.restore();
            M.save();
            M.beginPath();
            M.fillStyle = L;
            M.fillRect(20, 0, parseInt(N.width) - 50, y.height);
            M.closePath();
            M.restore();
            M.fillStyle = "#000000";
            M.beginPath();
            M.arc(20 + (O * 100) / 255, parseInt(N.height) / 2, 4, 0, Math.PI * 2, true);
            M.closePath();
            M.fill();
            M.save();
            M.font = "12px monospace";
            M.textBaseline = "middle";
            M.fillStyle = "#ffffff";
            M.fillText(parseInt(O), 125, N.height / 2);
            M.restore()
        };
        var p = function(L) {
            l.save();
            l.beginPath();
            l.fillStyle = L;
            l.fillRect(20, 20, 80, 80);
            l.closePath();
            l.restore()
        };
        var o = function(N) {
            var M = function(R) {
                var P = "0123456789ABCDEF";
                var O = parseInt(R) % 16;
                var Q = (parseInt(R) - O) / 16;
                hex = "" + P.charAt(Q) + P.charAt(O);
                return hex
            };
            var L = M(N[0]) + M(N[1]) + M(N[2]);
            while (n.hasChildNodes()) {
                n.removeChild(n.lastChild)
            }
            n.appendChild(document.createTextNode("#"));
            n.appendChild(document.createTextNode(L));
            ApplicationValues.element_color = "#" + L
        };
        var k = function(N) {
            var M = N.pageX - A.offsetLeft - this.offsetLeft;
            var L = N.pageY - this.offsetTop;
            if (this.getAttribute("id") == "red") {
                C[0] = ((M - 20) * 255) / 100;
                if (C[0] > 255) {
                    C[0] = 255
                }
                if (C[0] < 0) {
                    C[0] = 0
                }
                j.clearRect(0, 0, parseInt(y.width), y.height);
                E(y, j, C[0], "#ff0000")
            }
            if (this.getAttribute("id") == "green") {
                C[1] = ((M - 20) * 255) / 100;
                if (C[1] > 255) {
                    C[1] = 255
                }
                if (C[1] < 0) {
                    C[1] = 0
                }
                t.clearRect(0, 0, parseInt(B.width), B.height);
                E(B, t, C[1], "#00ff00")
            }
            if (this.getAttribute("id") == "blue") {
                C[2] = ((M - 20) * 255) / 100;
                if (C[2] > 255) {
                    C[2] = 255
                }
                if (C[2] < 0) {
                    C[2] = 0
                }
                w.clearRect(0, 0, parseInt(D.width), D.height);
                E(D, w, C[2], "#0000ff")
            }
            o(C);
            p(ApplicationValues.element_color);
            x.updateBackgroundElementDiagram()
        };
        E(y, j, C[0], "#ff0000");
        E(B, t, C[1], "#00ff00");
        E(D, w, C[2], "#0000ff");
        p(ApplicationValues.element_color);
        o(C);
        h.addEventListener("mousedown", k, false);
        s.addEventListener("mousedown", k, false);
        v.addEventListener("mousedown", k, false);
        document.body.appendChild(A);
        A.style.top = (window.innerHeight - parseInt(A.offsetHeight)) / 2 + "px";
        A.style.left = (window.innerWidth - parseInt(A.offsetWidth)) / 2 + "px"
    }, 0, "modify_color");
    var a = _genericMenu;
    var d;
    for (d in a) {
        if (a[d].length == 3) {
            this._addMenuItem(this._tools_ul1, a[d][0], a[d][1], a[d][2])
        } else {
            if (a[d].length == 4) {
                this._addMenuItem(this._tools_ul1, a[d][0], a[d][1], a[d][2], a[d][3])
            }
        }
    }
    g = this._tools_div;
    c = document.createElement("h4");
    f = document.createTextNode("Diagram elements");
    c.onclick = function() {
        var j = document.getElementById("ud_tools_ul2");
        var h;
        if (j.style.display == "none") {
            j.style.display = "block";
            this.childNodes[0].setAttribute("src", "/assets/vertical_flow.png")
        } else {
            j.style.display = "none";
            this.childNodes[0].setAttribute("src", "/assets/horizontal_flow.png")
        }
    };
    b = document.createElement("img");
    b.setAttribute("src", "/assets/vertical_flow.png");
    c.appendChild(b);
    c.appendChild(f);
    g.insertBefore(c, this._tools_ul2)
};

Application.prototype._generateSpecificMenu = function() {
    var c;
    var d = this._tools_ul2;
    while (d.hasChildNodes()) {
        d.removeChild(d.firstChild)
    }
    if (this._selected) {
        var c, b;
        var a = _specificMenu[this._diagrams[this._selected].getType()];
        for (c in a) {
            if (a[c].length == 4) {
                this._addMenuItem(this._tools_ul2, a[c][0], a[c][1], a[c][2], a[c][3])
            } else {
                if (a[c].length == 3) {
                    this._addMenuItem(this._tools_ul2, a[c][0], a[c][1], a[c][2])
                }
            }
        }
        this._addMenuItem(this._tools_ul2, "Note", function(f, e, g) {
            f.addElement(new UMLNote({x: e,y: g}))
        }, 1, "UMLNote");
        this._addMenuItem(this._tools_ul2, "Anchor", function(k, j, m, h, l) {
            var g = k.getElementByPoint(j, m);
            var f = k.getElementByPoint(h, l);
            if (g != null) {
                if (!f) {
                    f = new UMLNote({x: h,y: l});
                    k.addElement(f)
                }
                var e = new UMLLine({a: g,b: f});
                k.addElement(e)
            }
        }, 2, "UMLAnchor")
    }
};
Application.prototype.updateBackgroundElementDiagram = function() {
    for (i in this._diagrams) {
        this._diagrams[i].setBackgroundNodes(ApplicationValues.element_color)
    }
};
Application.prototype._interactionSingleClick = function(d) {
    var b = this._diagrams[this._selected];
    b.interaction(false);
    var c = this;
    var a = function(g) {
        var f = g.pageX - c._diagram_div.offsetLeft;
        var e = g.pageY - c._diagram_div.offsetTop;
        d(b, f, e);
        c._diagram_div.onmouseup = false;
        b.draw();
        b.interaction(true)
    };
    this._diagram_div.onmouseup = a
};
Application.prototype._interactionDoubleClick = function(g) {
    var c = this._diagrams[this._selected];
    c.interaction(false);
    var b = 0, d = 0;
    var f = true;
    var e = this;
    var a = function(k) {
        var j = k.pageX - e._diagram_div.offsetLeft;
        var h = k.pageY - e._diagram_div.offsetTop;
        if (f) {
            f = false;
            b = j;
            d = h
        } else {
            g(c, b, d, j, h);
            e._diagram_div.onclick = false;
            c.draw();
            c.interaction(true)
        }
    };
    this._diagram_div.onclick = a
};
Application.prototype._addMenuItem = function(a, g, f, k, b) {
    var h = document.createElement("li");
    
    var e = document.createElement("a");
	  
    var j = document.createTextNode(g);
    if (b) {
    	var C = document.createElement("img");
        C.setAttribute("src", "/assets/" + b + ".png");
        C.setAttribute("style", "position:absolute;");
        h.appendChild(C)
        var c = document.createElement("img");
        c.setAttribute("class","item");
        c.setAttribute("style", "position:absolute;");
        c.setAttribute("src", "/assets/" + b + ".png");
        h.appendChild(c)
    }
    e.appendChild(j);
    h.appendChild(e);
    a.appendChild(h);
    var d = this;
    switch (k) {
        case 0:
            h.addEventListener("click", function() {
                if (d._selected) {
                    f(d, d._diagrams[d._selected])
                } else {
                    f(d)
                }
            }, false);
            break;
        case 1:
            h.addEventListener("mousedown", function() {
                if (d._selected) {
                	this.setAttribute("class","active");
                	if(active_el!=null&&active_el!=this){
                		active_el.setAttribute("class","inactive");
                	}
                	active_el=this;
           
                    d._interactionSingleClick(f)
                }
            }, false);
            break;
        case 2:
            h.addEventListener("click", function() {
                if (d._selected) {
                	this.setAttribute("class","active");
                	if(active_el!=null){
                		active_el.setAttribute("class","inactive");
                	}
                	active_el=this;
                    d._interactionDoubleClick(f)
                }
            }, false);
            break;
        default:
            break
    }
};

Application.prototype._addSubmit = function(a, g, f, k, b) {

    var d = this;
                if (d._selected) {
                    f(d, d._diagrams[d._selected])
                } else {
                    f(d)
                }
 
};

Application.prototype.getXML = function() {
    var b = (new DOMParser()).parseFromString("<umldiagrams/>", "text/xml");
    var d = b.getElementsByTagName("umldiagrams")[0];
    var a;
    var c;
    for (c in this._diagrams) {
        a = this._diagrams[c].getXML(b);
        d.appendChild(a)
    }
    return b
};
Application.prototype.getCurrentXML = function() {
    var b = (new DOMParser()).parseFromString("<umldiagrams/>", "text/xml");
    var c = b.getElementsByTagName("umldiagrams")[0];
    var a;
    a = this._diagrams[this._selected].getXML(b);
    c.appendChild(a);
    return b
};
Application.prototype.getXMLString = function() {
    return (new XMLSerializer()).serializeToString(this.getXML())
};
Application.prototype.getCurrentXMLString = function() {
    return (new XMLSerializer()).serializeToString(this.getCurrentXML())
};
Application.prototype.setXML = function(xml) {
    var application = xml.getElementsByTagName("umldiagrams")[0];
    if (!application) {
        alert("Not found a valid XML string");
        return
    }
    var xmlnodes = application.childNodes;
    var aux, nodeName;
    var i, j;
    for (i = 0; i < xmlnodes.length; i++) {
        nodeName = xmlnodes[i].nodeName;
        for (j in _acceptedDiagrams) {
            if (nodeName == _acceptedDiagrams[j]) {
                aux = eval("new " + nodeName + "()");
                if (nodeName != "UMLProfile") {
                    aux.setXML(xmlnodes[i], _stereotypes)
                } else {
                    aux.setXML(xmlnodes[i], this._diagrams, _acceptedElementsUML);
                    this.storeInformationProfile(aux)
                }
                this.addDiagram(aux);
                break
            }
        }
    }
};
Application.prototype.storeInformationProfile = function(b) {
    var c = b.getElements();
    for (var a = 0; a < c[0].length; a++) {
        _metaclass.push(c[0][a])
    }
    for (a = 0; a < c[1].length; a++) {
        _stereotypes.push(c[1][a])
    }
};
Application.prototype.foundInArray = function(c, b) {
    for (var a = 0; a < c.length; a++) {
        if (b == c[a]) {
            return true
        }
    }
    return false
};
Application.prototype.setXMLString = function(a) {
    a = a.replace(/\n/gi, "");
    this.setXML((new DOMParser()).parseFromString(a, "text/xml"))
};

_acceptedDiagrams.push("UMLSequenceDiagram");
_acceptedElementsUML.push(["Lifeline", "UMLLifeline"], ["Option", "UMLOption"], ["Alternative", "UMLAlternative"], ["Loop", "UMLLoop"], ["Break", "UMLBreak"]);
_genericMenu.push(["New sequence diagram", function(a) {
        a.addDiagram(new UMLSequenceDiagram({backgroundNodes: ApplicationValues.element_color,stereotypes: _stereotypes}))
    }, 0, "UMLSequenceDiagram"]);
_specificMenu.UMLSequenceDiagram = [["Lifeline", function(b, a, d) {
            var c = new UMLLifeline({x: a,y: 70});
            b.addElement(c)
        }, 1, "UMLLifeline"], ["Create", function(e, d, g, c, f) {
            var b = e.getElementByPoint(d, g);
            var a = e.getElementByPoint(c, f);
            if (b && a && b != a && (b.getType() == "UMLLifeline" || b.getType() == "TimeInterval") && a.getType() == "UMLLifeline" && !a.getCreate()) {
                e.addElement(new UMLCreate({a: b,b: a,y: g}))
            }
        }, 2, "UMLCreate"], ["Destroy", function(e, d, g, c, f) {
            var b = e.getElementByPoint(d, g);
            var a = e.getElementByPoint(c, f);
            if (b && a && b != a && (b.getType() == "UMLLifeline" || b.getType() == "TimeInterval") && a.getType() == "UMLLifeline" && !a.getDelete()) {
                e.addElement(new UMLDestroy({a: b,b: a,y: g}))
            }
        }, 2, "UMLDestroy"], ["Option", function(b, a, d) {
            var c = new UMLOption({x: a,y: d});
            b.addElement(c)
        }, 1, "UMLInteraction"], ["Alternative", function(b, a, d) {
            var c = new UMLAlternative({x: a,y: d});
            b.addElement(c)
        }, 1, "UMLInteraction"], ["Loop", function(b, a, d) {
            var c = new UMLLoop({x: a,y: d});
            b.addElement(c)
        }, 1, "UMLInteraction"], ["Break", function(b, a, d) {
            var c = new UMLBreak({x: a,y: d});
            b.addElement(c)
        }, 1, "UMLInteraction"], ["Send Message", function(e, d, g, c, f) {
            var b = e.getElementByPoint(d, g);
            var a = e.getElementByPoint(c, f);
            if (b && a && (b.getType() == "UMLLifeline" || b.getType() == "TimeInterval") && (a.getType() == "UMLLifeline" || a.getType() == "TimeInterval")) {
                e.addElement(new UMLSendMessage({a: b,b: a,y: g}))
            }
        }, 2, "UMLSendMessage"], ["Call Message", function(e, d, g, c, f) {
            var b = e.getElementByPoint(d, g);
            var a = e.getElementByPoint(c, f);
            if (b && a && (b.getType() == "UMLLifeline" || b.getType() == "TimeInterval") && (a.getType() == "UMLLifeline" || a.getType() == "TimeInterval")) {
                e.addElement(new UMLCallMessage({a: b,b: a,y: g}))
            }
        }, 2, "UMLCallMessage"], ["Reply Message", function(e, d, g, c, f) {
            var b = e.getElementByPoint(d, g);
            var a = e.getElementByPoint(c, f);
            if (b != a && b != null && (b.getType() == "UMLLifeline" || b.getType() == "TimeInterval") && (a.getType() == "UMLLifeline" || a.getType() == "TimeInterval")) {
                e.addElement(new UMLReplyMessage({a: b,b: a,y: g}))
            }
        }, 2, "UMLReplyMessage"], ["Delete Message", function(e, d, g, c, f) {
            var b = e.getElementByPoint(d, g);
            var a = e.getElementByPoint(c, f);
            if (b && a && b != a && (b.getType() == "UMLLifeline" || b.getType() == "TimeInterval") && a.getType() == "UMLLifeline" && !a.getDelete()) {
                e.addElement(new UMLDeleteMessage({a: b,b: a,y: g}))
            }
        }, 2, "UMLDeleteMessage"], ];

_acceptedDiagrams.push("UMLProfile");
Application.prototype.setProfileGenericMenu = function() {
    var a = this;
    _genericMenu.push(["New profile", function(b) {
            b.addDiagram(new UMLProfile({backgroundNodes: ApplicationValues.element_color,diagrams: a._diagrams,validMetaclass: _acceptedElementsUML}))
        }, 0, "UMLProfile"])
};
_specificMenu.UMLProfile = [["Metaclass", function(c, a, d) {
            var b = new UMLMetaclass({x: a,y: d});
            _metaclass.push(b);
            c.addElement(b)
        }, 1, "UMLMetaclass"], ["Stereotype", function(b, a, d) {
            var c = new UMLStereotype({x: a,y: d});
            _stereotypes.push(c);
            b.addElement(c)
        }, 1, "UMLStereotype"], ["Extension", function(c, b, e, a, d) {
            c.addRelationFromPoints(new UMLExtension(), b, e, a, d)
        }, 2, "UMLExtension"]];
        

