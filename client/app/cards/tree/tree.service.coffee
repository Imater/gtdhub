'use strict'

angular.module('gtdhubApp').service 'treeSrv', (Hierarhy, Id, Stage, Task) ->
  # AngularJS will instantiate a singleton by calling 'new' on this function

  MAX_COLOR_STYLES = 15
  lastIndex = 1;
  randomColor = ->
    #randomIndex = Math.round(Math.random()*(colors.length-1))
    if lastIndex < MAX_COLOR_STYLES-1
      lastIndex++
    else
      lastIndex = 1
    lastIndex

  text = [
    "Президент РФ Владимир Путин подписал поправки в федеральный закон «О собраниях, митингах, демонстрациях, шествиях и пикетированиях», запрещающие митинговать в ночное время.Путин в преддверии своего дня рождения одобрил изменения в федеральный закон, согласно которым в России запрещается проводить массовые мероприятия в ночное время. Соответствующий документ сегодня, 6 октября, был размещен на официальном портале правовой информации."
    "Согласно подписанным изменениям в ФЗ «О собраниях, митингах, демонстрациях, шествиях и пикетированиях», публичное мероприятие не может начинаться раньше 07:00 утра и не может длиться позже, чем до 22:00 вечера текущего дня по местному времени."
    "Также в законе прописана возможность исключения, которое может быть сделано для публичных мероприятий, посвященных памятным датам, а также публичных мероприятий культурного (не политического) характера и содержания."
    "Трудно поверить в то, что тем, кому запрещено собираться больше одного днем, будут проявлять желание собираться ночью."
    "Жители Украины получают самую маленькую зарплату среди граждан остальных европейских стран. Такие данные приводит Евростат, который опубликовал обновленный рейтинг средних зарплат по итогам 2013 года."
    "Условия поставок газа на Украину должны быть достаточно приемлемыми для этой страны, заявил премьер-министр Дмитрий Медведев. Нужно продолжить поиск компромиссов."
    "О том, что против Путина готовится заговор - сегодня не говорит только ленивый. Санкции оказались самой действенной мерой в ситуации, когда вся путинская элита мотивированна исключительно жаждой наживы. "
    "Глава синодального Отдела по взаимоотношениям Церкви и общества протоиерей Всеволод Чаплин заявил, что не намерен менять свой традиционный паспорт на электронный."
    "Президент России Владимир Путин подписал закон, предусматривающий, что Центробанк должен перечислять в федеральный бюджет на постоянной основе 75% своей прибыли, а не 50%, как это было ранее."
    "Два крупнейших иностранных банка в России сильно поднажали на рынке рублевых облигаций, дабы сократить финансирование от своих материнских европейских компаний и спешат как можно скорее снизить от них свою зависимость, сообщает FTimes"
    "Депутат ЗакСа Петербурга Виталий Милонов заявил, что украинская певица София Ротару не имеет права зарабатывать деньги с помощью концертов на территории РФ"
    "Контрразведка Службы безопасности Украины разоблачила завербованного спецслужбами РФ гражданина Украины, бывшего пограничника-контрактника спецподразделения, которому российские кураторы поручили сбор"
    "В России сформировалось «поколение Путина»."
    "Украинские власти готовы к перезагрузке отношений с РФ при выполнении российским руководством определенных условий"
    "Альянс создает ударные группировки вблизи границ РФ.  НАТО разместит передовую группу Сил быстрого реагирования в Польше. Такой вывод можно сделать из жесткого заявления нового генсека альянса Йенса Столтенберга, которое он сделал в понедельник,"
    "К написанию статьи подтолкнуло прочтение статьи с похожим названием, последнее посещение Embedded World и опыт разработки в этой области."
    "Почему-то, когда говорят о тестировании применительно к встраиваемым системам, почти всегда подразумевают под этим платформу, позволяющую «отрезать» эту самую встраиваемую систему, чтобы «независимо от аппаратной платформы» протестировать написанный код."
    "Данный метод требует прямых рук наноботов — используйте описанное на свой страх и риск."
  ]

  class Tree extends Hierarhy
    constructor: (title) ->
      super
      @title = title || 'Новый проект'
      @colorIndex = randomColor()
      @text = text[Math.round(Math.random()*(text.length-1))]
      @id = Id.get()
    addStage: (stage)->
      @stage = [] if !@stage
      @stage.push stage
      stage



  main = undefined
  treeSrv =
    _Tree: Tree

    get: (id)->
      if !main
        main = @load()
      if !id
        return main
      else
        return main.getFind [], (el)->
          el if el.id == parseInt(id)

      main
    load: ()->
      main = new Tree '1. Working'
      main.open = true
      main2 = main.addChild new Tree '1.1 NetEagles'
      main2.open = true
      main3 = main2.addChild new Tree '1.2.1 Web-projects'
      miass = main3.addChild new Tree '1.2.1.1 Miass'
      main8 = main2.addChild new Tree '1.2.2 Soft-projects'
      main9 = main8.addChild new Tree '1.2.2.1 Go-soft'
      main9 = main8.addChild new Tree '1.2.2.2 Angular-soft'
      main9 = main9.addChild new Tree 'Inside Angular'
      main9.addChild new Tree 'Inside Angular1'

      main2.addChild new Tree '1.2.1 Inside Web-projects1'
      main2.addChild new Tree '1.2.1 Inside Web-projects2'
      main2.addChild new Tree '1.2.1 Inside Web-projects3'
      main2.addChild new Tree '1.2.1 Inside Web-projects4'
      main2.addChild new Tree '1.2.1 Inside Web-projects5'
      main.addChild new Tree 'Main 1'
      main.addChild new Tree 'Main 2'
      main.addChild new Tree 'Main 3'
      main.addChild new Tree 'Main 4'
      main.addChild new Tree 'Main 5'


      s = main9.addChild new Tree 'Inside Angular2'
      s.addChild new Tree 'Inside Angular2 !!!'
      main9.addChild new Tree 'Inside Angular3'
      main9.addChild new Tree 'Inside Angular4'
      main9.addChild new Tree 'Inside Angular5'


      main9 = main8.addChild new Tree '1.2.2.3 Coffee-soft'
      main9 = main8.addChild new Tree '1.2.2.4 Git-soft'

      main4 = main.addChild new Tree '1.2 Home projects'
      main4.addChild new Tree '1.2.1 Health'
      s = main4.addChild new Tree '1.2.2 Run'
      s.addChild new Tree 'Inside Run1'
      s.addChild new Tree 'Inside Run2'
      s.addChild new Tree 'Inside Run3'
      s.addChild new Tree 'Inside Run4'
      s.addChild new Tree 'Inside Run5'
      s.addChild new Tree 'Inside Run6'
      s.addChild new Tree 'Inside Run7'
      s.addChild new Tree 'Inside Run8'
      main4.addChild new Tree '1.2.3 Food'


      stage1 = miass.addStage new Stage { title: 'Back log', treeId: miass.id }
      stage1.addTask new Task {title: 'Сделать Drag&Drop'}
      stage1.addTask new Task {title: 'Посмотреть фильм'}
      stage1.addTask new Task {title: 'Скачать новую операционку'}

      stage1 = miass.addStage new Stage { title: 'To-do', treeId: miass.id }
      stage1.addTask new Task {title: 'Сделать Drag&Drop'}
      stage1.addTask new Task {title: 'Посмотреть фильм'}

      stage1 = miass.addStage new Stage { title: 'Doing', treeId: miass.id }
      stage1.addTask new Task {title: 'Сделать Drag&Drop'}

      stage1 = miass.addStage new Stage { title: 'Done', treeId: miass.id }
      stage1.addTask new Task {title: 'Сделать Drag&Drop'}
      stage1.addTask new Task {title: 'Посмотреть фильм'}
      stage1.addTask new Task {title: 'Скачать новую операционку'}
      stage1.addTask new Task {title: 'Сделать Drag&Drop'}
      stage1.addTask new Task {title: 'Посмотреть фильм'}
      stage1.addTask new Task {title: 'Скачать новую операционку'}

      main3 = main4.addChild new Tree 'Trello'
      main3.addStage new Stage { title: 'To-do', treeId: miass.id }
      main3.addStage new Stage { title: 'Doing', treeId: miass.id }
      main3.addStage new Stage { title: 'Done', treeId: miass.id }


      main
  treeSrv
