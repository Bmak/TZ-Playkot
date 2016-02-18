package 
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.sampler.getSize;
	/**
	 * Задачки для ТЗ Plakot
	 * @author ProBigi
	 */
	public class Tasks extends Sprite
	{
		
		public function Tasks() 
		{
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			//Примеры реализации
			BinaryOutput(-100);
			BinaryOutput(0);
			BinaryOutput(1532);
			BinaryOutput(int.MAX_VALUE);
			RemoveDupChars("AAA BBB AAA");
			RemoveDupChars("ABC DDD ASASSSS");
		}
		
		/**
		 * Функция, печатающая целое знаковое число в двоичном представлении
		 * @param	n - целое знаковое число
		 * @return	двоичное представление числа в виде строки
		 */
		private function BinaryOutput(n:int):String {
			var result:String = "";
			
			// Частный случай - n равно нулю
			if (n == 0) {
				result = "0";
				trace(result);
				return result;
			}
			
			// создаем маску из нулей
			// как правило стандартный размер int - 4 байта, если брать значение большее int, то он будет занимать 8 байт
			var size:int = getSize(n) * 8 - 2;
			var mask:int = 1 << size;
			
			// Пропускаем бесполезные нули слева
			var skipZero:int = 0;
			
			var c:int;
			
			
			while (mask) {
				// Определим текущий бит
				c = (n & mask) ? 1 : 0;
				
				// Отключим пропуск нулей в дальнейшем
				if (skipZero && c) {
					skipZero = 0;
				}
				
				if (!skipZero) {
					result += c;
				}
				// Сдвинем маску на один бит вправо
				mask >>= 1;
			}
			trace(result);
			return result;
		}
		
		/**
		 * Функция, которая удаляет из строки последовательно дублирующиеся символы в строке.
		 * @param	str - исходная строка
		 * @return	обработанная строка
		 */
		private function RemoveDupChars(str:String):String {
			var result:String = "";
			var lastChar:String;
			var len:int = str.length;
			for (var i:int = 0; i < len; i++) {
				if (i > 0 && str.charAt(i) == lastChar) {
					continue;
				}
				lastChar = str.charAt(i);
				result += lastChar;
			}
			trace(result);
			return result;
		}
	}

}