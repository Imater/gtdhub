'use strict'

angular.module('gtdhubApp').controller 'BlogCtrl', ($scope) ->
  $scope.filterBlogTreeMenu = {
    title: "All blog"
    cnt: 23
    childs: [
      title: 'CoffeeScript'
      cnt: 5
    ,
      title: 'Angular'
      cnt: 6
      childs: [
        title: 'Directives'
        cnt: 4
      ,
        title: 'Filters'
        cnt: 1
      ,
        title: 'Services'
        cnt: 2
      ,
        title: 'UI Router'
        cnt: 3
      ]
    ,
      title: 'HTML'
      cnt: 12
    ]
  }

  $scope.article =
    title: 'IXION — новый концепт «прозрачного» самолета'
    html: '''
<p>
	Ну раз уж пятница, то можно и помечтать, хотя это будущее не так уж далеко, как кажется на первый взгляд. Парижская дизайнерская студия Technicon Design недавно победила в конкурсе <a href="http://thedesignawards.co.uk/yachtandaviation/">Yacht &amp; Aviation Award</a> с их проектом IXION Windowless Jet Concept. Идея заключается в панорамной съемке внешними камерами самолета и отображении этой картинки на мониторах с высоким разрешением, которые вмонтированы в стены и потолок самолета.
</p>
<p>
	<img src="http://habrastorage.org/files/0d6/e52/8a7/0d6e528a771f43e8a26cc723f32249f4.jpg" style="font-size: 13px; color: rgb(0, 0, 0); font-family: Verdana, sans-serif; background-color: rgb(255, 255, 255);"><br>
	<a href="http://blog.technicondesign.com/2014/05/technicon-design-france-team-received.html">пресс-релизе</a> директор департамента дизайна Гарэт Дэвис.
</p>
<iframe width="560" height="349" src="http://www.youtube.com/embed/ndcG_4A38Z4?wmode=opaque" frameborder="0" allowfullscreen="" style="margin-bottom: 0px; border: 0px; font-size: 13px; color: rgb(0, 0, 0); font-family: Verdana, sans-serif; line-height: 20.799999237060547px; background-color: rgb(255, 255, 255);">
</iframe>
<p>
	Фотографии концепта
</p>
<p>
	<br>
	Но Technicon Design, конечно же, не первые пришли на рынок с этой идеей. Ранее в 2012 году на Парижском авиашоу Airbus уже<a href="https://www.youtube.com/watch?v=9OsOFZCwlT8">презентовал</a> концепт пассажирского авиалайнера с вмонтированными мониторами по всему салону. А бостонская компания Spike Aerospace пошла еще дальше и уже создает такой джет <a href="http://www.spikeaerospace.com/s-512-supersonic-jet/">S-512</a>, который будет курсировать по маршруту Лондон &mdash; Нью-Йорк со скоростью 1'770 км/час и перевозить на борту до 18 пассажиров. Начало продаж S-512 запланировано на декабрь 2018 года, предварительная стоимость £48'000'000.
</p>
  '''