
#Область ПрограммныйИнтерфейс

// Создать новую команду формы.
//
// Параметры:
//  Форма						 - ФормаКлиентскогоПриложения	 - Форма клиентского приложения.
//  ИмяКоманды			 - Строка											 - Имя команды.
//  Заголовок				 - Строка											 - Заголовок команды.
//  ИмяДействия			 - Строка											 - Имя процедуры действия команды: "Процедура <ИмяДействия>(Команда)".
//  СтруктураСвойств - Структура									 - Где ключ - имя свойства, значение - значение свойства.
//
Процедура СоздатьКоманду(Форма,ИмяКоманды,Заголовок,ИмяДействия,СтруктураСвойств=Неопределено) Экспорт
	
	НоваяКоманда = Форма.Команды.Добавить(ОчиститьОтЗапрещенныхСимволов(ИмяКоманды));
	НоваяКоманда.Заголовок = Заголовок;
	НоваяКоманда.Действие = ОчиститьОтЗапрещенныхСимволов(ИмяДействия);
	ЕслиСтруктураНеопределеноТоНовая(СтруктураСвойств);
	УстановитьСвойстваЭлементу(НоваяКоманда, СтруктураСвойств);
	
КонецПроцедуры

// Создать новую команду формы.
//
// Параметры:
//  Форма						 - ФормаКлиентскогоПриложения	 - Форма клиентского приложения.
//  ИмяКоманды			 - Строка											 - Имя команды.
//  Заголовок				 - Строка											 - Заголовок команды.
//  ИмяДействия			 - Строка											 - Имя процедуры действия команды: "Процедура <ИмяДействия>(Команда)".
//  СтруктураСвойств - Структура									 - Где ключ - имя свойства, значение - значение свойства.
// 
// Возвращаемое значение:
//   - КомандаФормы - созданная команда формы.
//
Функция СоздатьКомандуСВозвратом(Форма,ИмяКоманды,Заголовок,ИмяДействия,СтруктураСвойств=Неопределено) Экспорт
	
	НоваяКоманда = Форма.Команды.Добавить(ОчиститьОтЗапрещенныхСимволов(ИмяКоманды));
	НоваяКоманда.Заголовок = Заголовок;
	НоваяКоманда.Действие = ОчиститьОтЗапрещенныхСимволов(ИмяДействия);
	ЕслиСтруктураНеопределеноТоНовая(СтруктураСвойств);
	УстановитьСвойстваЭлементу(НоваяКоманда, СтруктураСвойств);
	Возврат НоваяКоманда;
	
КонецФункции

// Удаляет СОЗДАННУЮ ПРОГРАММНО команду формы.
//
// Параметры:
//  Форма			 - ФормаКлиентскогоПриложения	 - Форма клиентского приложения.
//  ИмяКоманды - Строка											 - Имя команды.
//
Процедура УдалитьКоманду(Форма,ИмяКоманды) Экспорт
	
	Форма.Команды.Удалить(Форма.Команды.Найти(ИмяКоманды));
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Создает новую строку очищенную от запрещенных символов.
//
// Параметры:
//  ПроверяемаяСтрока			 - Строка	 - Имя элемента.
//  ДопРазрешенныеСимволы	 - Строка	 - Дополнительно разрешенные символы.
// 
// Возвращаемое значение:
//   - Строка - Очищенная от запрещенных символов.
//
Функция ОчиститьОтЗапрещенныхСимволов(ПроверяемаяСтрока,ДопРазрешенныеСимволы="")
	
	Если НЕ ЗначениеЗаполнено(ПроверяемаяСтрока) Тогда
		Возврат ПроверяемаяСтрока;
	КонецЕсли;
	
	ОчищеннаяСтрока = "";
	РазрешенныеСимволы = "абвгдеёжзийклмнопрстуфхцчшщъыьэюяАБВГДЕЁЖЗИЙКЛМНОПРСТУФХЦЧШЩЪЫЬЭЮЯ" + "abcdefghijklmnopqrstuvwxyzQWERTYUIOPASDFGHJKLZXCVBNM" + "0123456789_";
	Если СтрДлина(ДопРазрешенныеСимволы) > 0 Тогда
		РазрешенныеСимволы = РазрешенныеСимволы + ДопРазрешенныеСимволы;
	КонецЕсли;
	Для Сч = 1 по СтрДлина(СокрЛП(ПроверяемаяСтрока)) Цикл
		ТекСимв = Сред(ПроверяемаяСтрока, Сч, 1);
		Если Найти(РазрешенныеСимволы, ТекСимв) > 0 Тогда
			ОчищеннаяСтрока = ОчищеннаяСтрока + ТекСимв;
		КонецЕсли;
	КонецЦикла;
	Возврат ОчищеннаяСтрока;
	
КонецФункции

// Устанавливает определенной команде формы заданные свойства.
//
// Параметры:
//  Элемент									 - КомандаФормы.
//  СтруктураСвойств				 - Структура - Ключ - имя свойства элемента формы, Значение - значение свойства элемента формы.
//
Процедура УстановитьСвойстваЭлементу(Элемент,СтруктураСвойств)
	
	Для Каждого тСвойство Из СтруктураСвойств Цикл
		Элемент[тСвойство.Ключ] = тСвойство.Значение;
	КонецЦикла;
	
КонецПроцедуры

// Проверяет значение структуры.
// Если значение "Неопределено", тогда значение заменяется на пустую структуру.
//
// Параметры:
//  ТекущаяСтруктура - Структура - Переданная структура или новая пустая структура.
//
Процедура ЕслиСтруктураНеопределеноТоНовая(ТекущаяСтруктура)
	
	Если ТекущаяСтруктура = Неопределено Тогда ТекущаяСтруктура = Новый Структура; КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
