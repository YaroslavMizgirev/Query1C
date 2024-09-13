//////////////////////////////////////////////////////////////////////////////////
//
//	Модуль Обработка строк
//	Начало разработки 01.07.2024 года
//	
//	Автор и разработчик: Мизгирев Ярослав Михайлович
//	При поддержке участников сообщества GitHub
//	https://github.com/YaroslavMizgirev/1C
//	telegram: https://t.me/YaroslavMizgirev
//	
//////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Функция - Строка в число.
//  Преобразует исходную строку в число без вызова исключений.
//
// Параметры:
//  Значение - Строка	 - строка, которую необходимо привести к числу. Например:
//  	"10", "+10", "010" - вернет 10;
//  	"(10)", "-10" - вернет -10;
//  	"10,2", "10.2" - вернет 10.2;
//  	"000", " ", "", ".", "0.0", "0.", ".0", ",", "0,0", "0,", ",0" - вернет 0;
//  	"10текст" - вернет Неопределено.
// 
// Возвращаемое значение:
//  Число, Неопределено - полученное число, либо Неопределено, если строка не является числом.
//
Функция СтрокаВЧисло(Знач Значение) Экспорт
	
	Значение  = СтрЗаменить(Значение, " ", "");
	Если СтрНачинаетсяС(Значение, "(") Тогда
		Значение = СтрЗаменить(Значение, "(", "-");
		Значение = СтрЗаменить(Значение, ")", "");
	КонецЕсли;
	
	СтрокаБезНулей = СтрЗаменить(Значение, "0", "");
	Если ПустаяСтрока(СтрокаБезНулей) Или СтрокаБезНулей = "-" Или СтрокаБезНулей = "." Или СтрокаБезНулей = "," Тогда Возврат 0; КонецЕсли;
	
	Результат = _ТипЗначения.ОписаниеТипаЧисло().ПривестиЗначение(Значение);
	Возврат ?(НЕ Результат = 0, Результат, Неопределено);
	
КонецФункции

// Функция - Имя в синоним.
//  Преобразует строку Имя в стиле "CamelCase" в строку Синоним в виде "Camel Case".
//
// Параметры:
//  Строка - Строка	 - входящая строка в стиле "CamelCase".
// 
// Возвращаемое значение:
//   - Строка - строка в виде "Camel Case".
//
Функция ИмяВСиноним(Строка) Экспорт
	
	Если СтрДлина(Строка) <= 1 Тогда Возврат Строка; КонецЕсли;
	
	ПромежуточныйРезультат = Новый Массив;
	ПозицияКурсора = 1;
	ВременныйМассив = Новый Массив;
	Пока ПозицияКурсора <= СтрДлина(Строка) Цикл
		Символ = Сред(Строка, ПозицияКурсора, 1);
		Если ЭтоСимволВерхнегоРегистра(Символ) Тогда
			Если ВременныйМассив.Количество() > 0 Тогда
				Индекс = 0;
				Слово = "";
				Пока Индекс < ВременныйМассив.Количество() Цикл
					Слово = Слово + ВременныйМассив[Индекс];
					Индекс = Индекс + 1;
				КонецЦикла;
				ПромежуточныйРезультат.Добавить(Слово);
				ВременныйМассив.Очистить();
			КонецЕсли;
			Символ = ?(ПромежуточныйРезультат.Количество() > 0, НРег(Символ), Символ);
		КонецЕсли;
		ВременныйМассив.Добавить(Символ);
		ПозицияКурсора = ПозицияКурсора + 1;
	КонецЦикла;
	
	Индекс = 0;
	Слово = "";
	Пока Индекс < ВременныйМассив.Количество() Цикл
		Слово = Слово + ВременныйМассив[Индекс];
		Индекс = Индекс + 1;
	КонецЦикла;
	ПромежуточныйРезультат.Добавить(Слово);
	
	Результат = "";
	Индекс = 0;
	Пока Индекс < ПромежуточныйРезультат.Количество() Цикл
		Если СтрДлина(Результат) > 0 Тогда
			Результат = Результат + " " + ПромежуточныйРезультат[Индекс];
		Иначе
			Результат = ПромежуточныйРезультат[Индекс];
		КонецЕсли;
		Индекс = Индекс + 1;
	КонецЦикла;
	Возврат Результат;
	
КонецФункции

// Функция - Очистить от запрещенных символов.
//  Возвращает строку с символами которые входят в состав: русского и/или английского алфавитов, цифр, общих разрешенных символов.
//  Дополнительно можно расширить перечень разрешенных символов передав их в параметре ДопРазрешенныеСимволы.
//
// Параметры:
//  ПроверяемаяСтрока			 - Строка	 - Имя элемента.
//  ДопРазрешенныеСимволы	 - Строка	 - Дополнительно разрешенные символы.
// 
// Возвращаемое значение:
//  Строка - Строка включающая в свой состав только разрешенные символы.
//
Функция ОчиститьОтЗапрещенныхСимволов(ПроверяемаяСтрока,ДопРазрешенныеСимволы="") Экспорт
	
	Если НЕ ЗначениеЗаполнено(ПроверяемаяСтрока) Тогда Возврат ПроверяемаяСтрока; КонецЕсли;
	
	ОчищеннаяСтрока = "";
	РазрешенныеСимволы = ВсеСимволыРусскогоАлфавита() + ВсеСимволыАнглийскогоАлфавита() + ВРег(ВсеСимволыРусскогоАлфавита() + ВсеСимволыАнглийскогоАлфавита()) + Цифры() + ОбщиеРазрешенныеСимволы();
	Если СтрДлина(ДопРазрешенныеСимволы) > 0 Тогда РазрешенныеСимволы = РазрешенныеСимволы + ДопРазрешенныеСимволы; КонецЕсли;
	
	Для Сч = 1 По СтрДлина(СокрЛП(ПроверяемаяСтрока)) Цикл
		ТекСимв = Сред(ПроверяемаяСтрока, Сч, 1);
		Если Найти(РазрешенныеСимволы, ТекСимв) > 0 Тогда
			ОчищеннаяСтрока = ОчищеннаяСтрока + ТекСимв;
		КонецЕсли;
	КонецЦикла;
	
	Возврат ОчищеннаяСтрока;
	
КонецФункции

// Функция - Это символ нижнего регистра.
//  Проверяет переданный символ, на соответствие символам русского или английского алфавитов в нижнем регистре.
//
// Параметры:
//  Символ - Строка	 - один символ.
// 
// Возвращаемое значение:
//   - Булево.
//
Функция ЭтоСимволНижнегоРегистра(Символ) Экспорт
	
	Набор = ВсеСимволыРусскогоАлфавита() + ВсеСимволыАнглийскогоАлфавита();
	Возврат СтрНайти(Набор, Символ) > 0;
	
КонецФункции

// Функция - Это символ верхнего регистра.
//  Проверяет переданный символ, на соответствие символам русского или английского алфавитов в верхнем регистре.
//
// Параметры:
//  Символ - Строка	 - один символ.
// 
// Возвращаемое значение:
//   - Булево.
//
Функция ЭтоСимволВерхнегоРегистра(Символ) Экспорт
	
	Набор = ВРег(ВсеСимволыРусскогоАлфавита() + ВсеСимволыАнглийскогоАлфавита());
	Возврат СтрНайти(Набор, Символ) > 0;
	
КонецФункции

// Функция - Это цифра.
//  Проверяет переданный символ, на соответствие символам цифр.
//
// Параметры:
//  Символ - Строка	 - один символ.
// 
// Возвращаемое значение:
//   - Булево.
//
Функция ЭтоЦифра(Знач Символ) Экспорт
	
	Возврат СтрНайти(Цифры(), Символ) > 0;
	
КонецФункции

// Функция - Это символы русского алфавита.
//  Проверяет переданную строку на соответствие символам русского алфавита.
//  Дополнительно можно расширить перечень разрешенных символов передав их в параметре ДопРазрешенныеСимволы.
//
// Параметры:
//  ПроверяемаяСтрока			 - Строка.
//  ДопРазрешенныеСимволы	 - Строка.
// 
// Возвращаемое значение:
//   - Булево.
//
Функция ЭтоСимволыРусскогоАлфавита(ПроверяемаяСтрока,ДопРазрешенныеСимволы="") Экспорт
	
	Если НЕ ЗначениеЗаполнено(ПроверяемаяСтрока) Тогда Возврат Ложь; КонецЕсли;
	
	РазрешенныеСимволы = ВсеСимволыРусскогоАлфавита() + ВРег(ВсеСимволыРусскогоАлфавита()) + ДопРазрешенныеСимволы;
	Для Сч = 1 По СтрДлина(СокрЛП(ПроверяемаяСтрока)) Цикл
		ТекСимв = Сред(ПроверяемаяСтрока, Сч, 1);
		Если Найти(РазрешенныеСимволы, ТекСимв) = 0 Тогда Возврат Ложь; КонецЕсли;
	КонецЦикла;
	Возврат Истина;
	
КонецФункции

// Функция - Это символы английского алфавита.
//  Проверяет переданную строку на соответствие символам английского алфавита.
//  Дополнительно можно расширить перечень разрешенных символов передав их в параметре ДопРазрешенныеСимволы.
//
// Параметры:
//  ПроверяемаяСтрока			 - Строка.
//  ДопРазрешенныеСимволы	 - Строка.
// 
// Возвращаемое значение:
//   - Булево.
//
Функция ЭтоСимволыАнглийскогоАлфавита(ПроверяемаяСтрока,ДопРазрешенныеСимволы="") Экспорт
	
	Если НЕ ЗначениеЗаполнено(ПроверяемаяСтрока) Тогда Возврат Ложь; КонецЕсли;
	
	РазрешенныеСимволы = ВсеСимволыАнглийскогоАлфавита() + ВРег(ВсеСимволыАнглийскогоАлфавита()) + ДопРазрешенныеСимволы;
	Для Сч = 1 По СтрДлина(СокрЛП(ПроверяемаяСтрока)) Цикл
		ТекСимв = Сред(ПроверяемаяСтрока, Сч, 1);
		Если Найти(РазрешенныеСимволы, ТекСимв) = 0 Тогда Возврат Ложь; КонецЕсли;
	КонецЦикла;
	Возврат Истина;
	
КонецФункции

// Функция - Это цифры.
//  Проверяет переданную строку на соответствие цифрам.
//  Дополнительно можно расширить перечень разрешенных символов передав их в параметре ДопРазрешенныеСимволы.
//
// Параметры:
//  ПроверяемаяСтрока			 - Строка.
//  ДопРазрешенныеСимволы	 - Строка.
// 
// Возвращаемое значение:
//   - Булево.
//
Функция ЭтоЦифры(ПроверяемаяСтрока,ДопРазрешенныеСимволы="") Экспорт
	
	Если НЕ ЗначениеЗаполнено(ПроверяемаяСтрока) Тогда Возврат Ложь; КонецЕсли;
	
	РазрешенныеСимволы = Цифры() + ДопРазрешенныеСимволы;
	Для Сч = 1 По СтрДлина(СокрЛП(ПроверяемаяСтрока)) Цикл
		ТекСимв = Сред(ПроверяемаяСтрока, Сч, 1);
		Если Найти(РазрешенныеСимволы, ТекСимв) = 0 Тогда Возврат Ложь; КонецЕсли;
	КонецЦикла;
	Возврат Истина;
	
КонецФункции

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

// Функция - Все символы русского алфавита.
//  Возвращает строку символов русского алфавита в нижнем регистре: "абвгдеёжзийклмнопрстуфхцчшщъыьэюя".
// 
// Возвращаемое значение:
//   - Строка.
//
Функция ВсеСимволыРусскогоАлфавита() Экспорт
	
	Возврат "абвгдеёжзийклмнопрстуфхцчшщъыьэюя";
	
КонецФункции

// Функция - Все символы английского алфавита.
//  Возвращает строку символов английского алфавита в нижнем регистре: "abcdefghijklmnopqrstuvwxyz".
// 
// Возвращаемое значение:
//   - Строка.
//
Функция ВсеСимволыАнглийскогоАлфавита() Экспорт
	
	Возврат "abcdefghijklmnopqrstuvwxyz";
	
КонецФункции

// Функция - Цифры.
//  Возвращает строку с цифрами: "0123456789".
// 
// Возвращаемое значение:
//   - Строка.
//
Функция Цифры() Экспорт
	
	Возврат "0123456789";
	
КонецФункции

// Функция - Общие разрешенные символы.
//  Возвращает строку с общим перечнем разрешенных символов: "_".
// 
// Возвращаемое значение:
//   - Строка.
//
Функция ОбщиеРазрешенныеСимволы() Экспорт
	
	Возврат "_";
	
КонецФункции

#КонецОбласти