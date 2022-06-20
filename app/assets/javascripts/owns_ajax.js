$(function () {
  $('#start_cal_own').click(function () {
    $("h1").css("color", "#0000FF");
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

    $.ajax({
      type: 'GET',
      url: '/owns/calcurate',
      data: { 
        start: Start.val(),
        finish: Finish.val(),
        calc: Calc.val(),
        free: Free.val(),

        first_from: FirstFrom.val(),
        first_to: FirstTo.val(),
        first_amount: FirstAmount.val(),
        second_from: SecondFrom.val(),
        second_to: SecondTo.val(),
        second_amount: SecondAmount.val(),
        third_from: ThirdFrom.val(),
        third_to: ThirdTo.val(),
        third_amount: ThirdAmount.val(),
        fourth_from: FourthFrom.val(),
        fourth_to: FourthTo.val(),
        fourth_amount: FourthAmount.val()

      }, // サーバーに送信するデータ
      dataType: 'json' // サーバーから返却される型
    })

    .done(function (data) {
      $('.js-messages li').remove();
      $('.js-messages p').remove();
      $('.js-messages h2').remove();
      if (data.job){
        $('.js-messages').append(
          `<p>${data.message}</p>
          <li class="message">超過${data.first_range[0]}日〜${data.first_range[1]}日：${data.first_tariff}円</li>
          <li class="message">超過${data.second_range[0]}日〜${data.second_range[1]}日：${data.second_tariff}円</li>
          <li class="message">超過${data.third_range[0]}〜${data.third_range[1]}：${data.third_tariff}円</li>
          <li class="message">超過${data.fourth_range[0]}〜${data.fourth_range[1]}：${data.fourth_tariff}円</li>
          <p>明細</p>
          <li class="message">フリータイム${data.free}日間（${data.calc}で計算しています）：${data.free_period[0]}〜${data.free_period[1]}</li>
          <li class="message">起算日${data.free_period[0]}</li>
          <li class="message">超過期間（１）${data.first_each_day[1]}日間（${data.first_each_day[0]}） x ${data.first_tariff}円 ＝ ${data.first_amount}円</li>
          <li class="message">超過期間（２）${data.second_each_day[1]}日間（${data.second_each_day[0]}） x ${data.second_tariff}円 ＝ ${data.second_amount}円</li>
          <li class="message">超過期間（３）${data.third_each_day[1]}日間（${data.third_each_day[0]}） x ${data.third_tariff}円 ＝ ${data.third_amount}円</li>
          <li class="message">超過期間（４）${data.fourth_each_day[1]}日間（${data.fourth_each_day[0]}） x ${data.fourth_tariff}円 ＝ ${data.fourth_amount}円</li>
          <h2>合計：${data.total_amount}円</h2>`
        );
      } else {
        $('.js-messages').append(
          `
          <p>${data.message}</p>
          `
        );
      }
    })


  });
});