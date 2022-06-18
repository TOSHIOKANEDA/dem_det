$(function () {
  $("input[id= rqd]").change(function(){

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

    var class_array = [Start, Finish, Free, FirstFrom, FirstTo, SecondFrom, SecondTo, ThirdFrom, ThirdTo, FourthFrom, FourthTo]
    var class_select_array = [Calc, FirstAmount, SecondAmount, ThirdAmount, FourthAmount]
// class_select_arrayから選択肢が選択してください、だったらfalseにする処理
    let send = true;
    $.each(class_array, function(i, value){CheckEmpty(value)})

    if (send) {
      $('#start_cal_own').css('display', 'block');
    } else {
      $('.js-messages').append(
        `
        <p>未選択・未入力部分があります</p>
        `
      );
    }
    
  })
})

function CheckEmpty(class_name){
  if(class_name.val() == '') {
    class_name.css('background-color', 'red');
    send = false
  } else {
    class_name.css('background-color', 'white');
  }
}