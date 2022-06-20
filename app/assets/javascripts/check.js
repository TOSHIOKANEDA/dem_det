$(function () {
  $("input[id= rqd], select[id= rqd]").change(function(){

    var Start = $('.start');
    var Finish = $('.finish');
    var Calc = $('.calc')
    var Free = $('.free_time')

    var FirstFrom = $('.first_from')
    var FirstTo = $('.first_to')
    var FirstAmount = $('.first_amount')
    var SecondFrom = $('.second_from')
    var SecondTo = $('.second_to')
    var SecondAmount = $('.second_amount')
    var ThirdFrom = $('.third_from')
    var ThirdTo = $('.third_to')
    var ThirdAmount = $('.third_amount')
    var FourthFrom = $('.fourth_from')
    var FourthTo = $('.fourth_to')
    var FourthAmount = $('.fourth_amount')

    var class_array = [Start, Finish, FirstFrom, FirstTo, SecondFrom, SecondTo, ThirdFrom, ThirdTo, FourthFrom, FourthTo]
    var class_select_array = [Free, Calc, FirstAmount, SecondAmount, ThirdAmount, FourthAmount]
    var from_to_array = [[FirstFrom.val(), FirstTo.val()],[SecondFrom.val(), SecondTo.val()], [ThirdFrom.val(), ThirdTo.val()], [FourthFrom.val(), FourthTo.val()] ]

    $.each(class_array, function(i, value){CheckEmpty(value)})
    $.each(class_select_array, function(i, value){CheckNoSelect(value)})
    $.each(from_to_array, function(i, value){CheckFromTo(i+1, value)})

    function CheckFromTo(i, class_set){
      if (parseInt(class_set[1]) == 999) {
        return false
      }
      if (parseInt(class_set[0]) - parseInt(class_set[1]) >= 0){
        $(".period_wrap_"+ i).css('background-color', 'red')
        c_fromto = false
      } else {
        $(".period_wrap_"+ i).css('background-color', 'white')
        c_fromto = true
      }
    }

    function CheckEmpty(class_name){
      if(class_name.val() == '') {
        class_name.css('background-color', 'red');
        c_empty = false
      } else {
        class_name.css('background-color', 'white');
        c_empty = true
      }
    }
    
    function CheckNoSelect(class_name){
      if (class_name.val() == '選択してください') {
        class_name.css('background-color', 'red');
        c_select = false
      } else {
        class_name.css('background-color', 'white');
        c_select = true
      }
    }


    if (c_empty && c_fromto && c_select) {
      $('#start_cal_own').css('display', 'block');
    } else {
      $('#start_cal_own').css('display', 'none');
    }
  })
})
