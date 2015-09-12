// Version: 2015-02-26

// Obsolete function
function aclara(a) {
	var d = a.split(".");
	var id = d[0].length + "." + (a.length - d[0].length - 1);

	if (id == "43.41") {
		return aclara_f(a);
	}
	return "";
}

function aclara_p(a,p) {
	var d = a.split(".");
	var id = d[0].length + "." + (a.length - d[0].length - 1);

	if (p == "en_US-vflbaqfRh") {
		return aclara_f(a);
	}
	return "";
}

function aclara_f(a) {
	a=a.split("");
	UF.cO(a,3);
	UF.MZ(a,26);
	UF.pw(a,23);
	UF.cO(a,1);
	UF.pw(a,19);
	UF.pw(a,43);
	UF.pw(a,36);
	return a.join("");
}

var UF ={MZ:function(a){a.reverse()},pw:function(a,b){var c=a[0];a[0]=a[b%a.length];a[b]=c},cO:function(a,b){a.splice(0,b)} };

// A: NDMuNDE=
// B: ZW5fVVMtdmZsYmFxZlJo
// C: MjAxNS0wMi0yNg==
// D: c3RzPTE2NDg5
// E: VUY=
