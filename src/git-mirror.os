
#Использовать cmdline
#Использовать "."

Перем Лог;

/////////////////////////////////////////////////////////////////////////////////////////

Функция ПолучитьПарсерКоманднойСтроки()
    
    Парсер = Новый ПарсерАргументовКоманднойСтроки();
    
    МенеджерКомандПриложения.ЗарегистрироватьКоманды(Парсер);
    
    Возврат Парсер;
    
КонецФункции

Функция ПолезнаяРабота()
    ПараметрыЗапуска = РазобратьАргументыКоманднойСтроки();
    Если ПараметрыЗапуска = Неопределено или ПараметрыЗапуска.Количество() = 0 Тогда
        Лог.Ошибка("Некорректные аргументы командной строки");
        МенеджерКомандПриложения.ПоказатьСправкуПоКомандам();
        Возврат 1;
    КонецЕсли;

    Если ТипЗнч(ПараметрыЗапуска) = Тип("Структура") Тогда
        // это команда
        Команда            = ПараметрыЗапуска.Команда;
        ЗначенияПараметров = ПараметрыЗапуска.ЗначенияПараметров;
    ИначеЕсли ЗначениеЗаполнено(ПараметрыСистемы.ИмяКомандыПоУмолчанию()) Тогда
        // это команда по-умолчанию
        Команда            = ПараметрыСистемы.ИмяКомандыПоУмолчанию();
        ЗначенияПараметров = ПараметрыЗапуска;
    Иначе
        ВызватьИсключение "Некорректно настроено имя команды по-умолчанию.";
    КонецЕсли;
    
    Возврат МенеджерКомандПриложения.ВыполнитьКоманду(Команда, ЗначенияПараметров);
    
КонецФункции

Функция РазобратьАргументыКоманднойСтроки()
    Парсер = ПолучитьПарсерКоманднойСтроки();
    Возврат Парсер.Разобрать(АргументыКоманднойСтроки);
КонецФункции

/////////////////////////////////////////////////////////////////////////

Лог = Логирование.ПолучитьЛог(ПараметрыСистемы.ИмяЛогаСистемы());
МенеджерКомандПриложения.РегистраторКоманд(ПараметрыСистемы);

Попытка
    ЗавершитьРаботу(ПолезнаяРабота());
Исключение
    Лог.КритичнаяОшибка(ОписаниеОшибки());
    ЗавершитьРаботу(255);
КонецПопытки;
