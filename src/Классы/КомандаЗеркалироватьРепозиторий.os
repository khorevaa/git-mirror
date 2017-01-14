///////////////////////////////////////////////////////////////////////////////////////////////////
// Прикладной интерфейс
#Использовать 1commands
#Использовать logos

Перем Лог;

Процедура ЗарегистрироватьКоманду(Знач ИмяКоманды, Знач Парсер) Экспорт
    
    ОписаниеКоманды = Парсер.ОписаниеКоманды(ИмяКоманды, "Зеркалирование репозитория git на другой сервер");
    Парсер.ДобавитьПозиционныйПараметрКоманды(ОписаниеКоманды, "URLРепозитория", "URL репозитория, который будет зеркалирован");
    Парсер.ДобавитьПозиционныйПараметрКоманды(ОписаниеКоманды, "URLНазначения", "URL репозитория приемника данных");
    Парсер.ДобавитьИменованныйПараметрКоманды(ОписаниеКоманды, "-ahead", "Дополнительный заголовок для репозитория приемника веток");
  

КонецПроцедуры

// Выполняет логику команды
// 
// Параметры:
//   ПараметрыКоманды - Соответствие ключей командной строки и их значений
//
Функция ВыполнитьКоманду(Знач ПараметрыКоманды) Экспорт
    
    URLРепозитория = ПараметрыКоманды["URLРепозитория"];
    URLНазначения = ПараметрыКоманды["URLНазначения"];
    ДополнительныеЗаголовок = ПараметрыКоманды["-ahead"];

    ЗеркалироватьРепозиторий(URLРепозитория,
                            URLНазначения,
                            ДополнительныеЗаголовок);

КонецФункции

Функция ЗеркалироватьРепозиторий(URLРепозитория,
                                    URLНазначения,
                                    ДополнительныеЗаголовок = Неопределено) Экспорт

    Лог = Логирование.ПолучитьЛог(ПараметрыСистемы.ИмяЛогаСистемы()); 

    КаталогКопии = СклонироватьРепозиторий(URLРепозитория);

    РезультатВыполнения = ОтправитьНаЗеркало(URLНазначения, КаталогКопии, ДополнительныеЗаголовок);

    Возврат РезультатВыполнения;

КонецФункции

Функция СклонироватьРепозиторий(URLРепозитория)

	Лог.Информация(СтрШаблон(">> Клонирование репозитория: %1", URLРепозитория));
	
	РабочийКаталог = ВременныеФайлы.СоздатьКаталог();
    
    КомандаЗапуска = Новый Команда;
    КомандаЗапуска.УстановитьКоманду("git");
    КомандаЗапуска.УстановитьРабочийКаталог(ПараметрыСистемы.БазовыйКаталогЗапуска());	
    КомандаЗапуска.ДобавитьПараметр("clone");

    КомандаЗапуска.ДобавитьПараметр("--mirror");
    КомандаЗапуска.ДобавитьПараметр(URLРепозитория);
    КомандаЗапуска.ДобавитьПараметр(РабочийКаталог);
    
    РезультатВыполнения = КомандаЗапуска.Исполнить();
        
    Если НЕ РезультатВыполнения = 0 Тогда
        ВызватьИсключение "Выполнение функции клонирования репозитория не удалось";
    КонецЕслИ;	
    Возврат РабочийКаталог;

КонецФункции

Функция ОтправитьНаЗеркало(URLРепозитория, РабочийКаталог, ДополнительныеЗаголовок = Неопределено)
	
	Лог.Информация(СтрШаблон(">> Отправка данных на репозиторий: %1", URLРепозитория));

    КомандаЗапуска = Новый Команда;
    КомандаЗапуска.УстановитьКоманду("git");
    КомандаЗапуска.УстановитьРабочийКаталог(РабочийКаталог);	
    КомандаЗапуска.ДобавитьПараметр("push");
    
    Если НЕ ЗначениеЗаполнено(ДополнительныеЗаголовок) Тогда
        КомандаЗапуска.ДобавитьПараметр("--mirror");
    КонецЕсли;

    КомандаЗапуска.ДобавитьПараметр(URLРепозитория);
    
    Если ЗначениеЗаполнено(ДополнительныеЗаголовок) Тогда
        СтрокаЗаголовков = СтрШаблон("refs/heads/*:refs/heads/%1/*", ДополнительныеЗаголовок);
        КомандаЗапуска.ДобавитьПараметр(СтрокаЗаголовков);
    КонецЕслИ;
    
    РезультатВыполнения = КомандаЗапуска.Исполнить();
    
    Если НЕ РезультатВыполнения = 0 Тогда
        ВызватьИсключение "Выполнение функции отправки на  репозитория не удалось";
    КонецЕслИ;	
    
    Возврат РезультатВыполнения;

КонецФункции


