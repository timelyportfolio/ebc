const arrayeq = function (arr1, arr2, fun) {
  if (!Array.isArray(arr1) || !Array.isArray(arr2)) {
    return false
  }

  if (arr1.length !== arr2.length) {
    return false
  }

  for (var i = 0; i < arr1.length; i++) {
    if (fun(arr1[i]) !== fun(arr2[i])) {
      return false
    }
  }

  return true
}

export {arrayeq}
