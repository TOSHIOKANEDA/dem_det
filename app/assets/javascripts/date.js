// fromがtoよりも上まらないようにするための制御
$(function () {
  $.each([".first", ".second", ".third", ".fourth"], function(i, value){
    $(value + "_from").on('input', function(){
      var selected = parseInt($(value + "_from").val()) + 1
      ChangeToDate($(value + "_to"), selected)
    })
  })
})

// 1stのtoの日数を2ndのfromの日数に１を足すないようにするための制御&minとmaxをselectedと同数にして固定化
$(function () {
  $.each([".first", ".second", ".third"], function(i, value){
    $(value + "_to").change(function(){
      var from_select = parseInt($(value + "_to").val()) + 1 // 次のfromに入れる変数（firstを動かしたらsecond）
      var to_select = from_select + 1 // 次のtoに入れる変数
      if (i==0){
        ChangeFromDate(".second_from", from_select)
        ChangeToDate(".second_to", to_select)
      } else if (i == 1){
        ChangeFromDate(".third_from", from_select)
        ChangeToDate(".third_to", to_select)
      } else if (i == 2){
        ChangeFromDate(".fourth_from", from_select)
        ChangeToDate(".fourth_to", to_select)
      }
    })
  })
})

function ChangeFromDate(class_name, selected){
  $(class_name).val(selected)
  $(class_name).attr('min', selected); //minとmaxをselectedと同数にして固定化
  $(class_name).attr('max', selected); //minとmaxをselectedと同数にして固定化
}

function ChangeToDate(class_name, selected){
  $(class_name).attr('min', selected); //minとmaxをselectedと同数にして固定化
}