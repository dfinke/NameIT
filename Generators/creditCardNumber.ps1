function creditCardNumber {
  $Value1 = get-random -Minimum 1000 -maximum 9999
  $Value2 = get-random -Minimum 1000 -maximum 9999
  $Value3 = get-random -Minimum 1000 -maximum 9999
  $Value4 = get-random -Minimum 1000 -maximum 9999
  $creditCardNumber = ("$value1" + ' ' + "$Value2" + ' ' + "$value3" + ' ' + "$value4")
  return ($creditCardNumber)
}
