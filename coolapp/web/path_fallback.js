(function () {
  var params = new URLSearchParams(window.location.search);
  var p = params.get('p');
  if (p) {
    history.replaceState(null, '', decodeURIComponent(p));
  }
})();
