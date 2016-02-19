package 
{
	import data.paymentModule.wind.menu.item.ItemModel;
	import flash.display.Sprite;
	import flash.utils.Timer;
	/**
	 * Каркас игрового проекта
	 * ТЗ Playkot
	 * @author ProBigi
	 */
	public class GameFrame 
	{
		
		public function GameFrame() 
		{
			
		}
		
	}
	
	//Базовый класс объекта, который отображается на игровой карте
	//С ним никаких взаимодействий не происходит
	public class BaseMapObject
	{
		public var posX:int;						//позиция на карте по Х
		public var posY:int;						//позиция на карте по Y
		
		protected var _view:Sprite;					//Визуальное представление объекта
		
		public function BaseMapObject() { }			//конструктор
		
		public function init() { }					//инициализация объекта и отображение на карте
		
		public function remove() { }				//удаление объекта с карты, очистка ресурсов
	}
	
	//Класс интерактивного объекта, с которым можно взаимодействовать на игровой карте
	public class InteractiveMapObject extends BaseMapObject
	{		
		public var health:int;						//Запас здоровья игрового объекта
		public var isVulnarable:Boolean;			//Флаг разрушаемый объект или нет
		
		public function InteractiveMapObject() { }
		
		/**
		 * Нанесение урона игровому объекту
		 * @param	damage - количество нанесенного урона
		 */
		public function takeDamage(damage:int):void {
			if (!isVulnarable) { return; }			//Неуязвимым объектам никакого урона не может наноситься
			
			health -= damage;						//условная логика нанесения урона
			
			if (health <= 0) { death(); }			//смерть объекта, после того как health дойдет до нуля
		}
		
		//Условная смерть игрового объекта, уничтожение, убирание с карты
		public function death():void { }
	}
	
	//Класс ресурсов, которые выпадают на карте и доступны для сбора (Доски, Гравий)
	public class ResourceObject extends InteractiveMapObject
	{
		public var _resType:int;					//Тип ресурса, который начисляется при сборе
		public var amount:int;						//количество выпавших ресурсов
		//Параметр  isVulnarable = false;
		
		public function ResourceObject() { }
		
		//При вызове этого метода ресурсный объект собирается с карты и начисляется игроку
		public function collect():void { }
	}
	
	//Класс добывающих объектов, после взаимодействия с которыми
	//выпадают игровые ресурсы (Дерево, Камень)
	public class MiningObject extends InteractiveMapObject
	{		
		public function MiningObject() { }
		
		/**
		 * Сбросить ресурсы заданного типа
		 * @param	type
		 */
		public function dropRes(type:int):void { }
	}
	
	//Класс объекта, который оказывает какое-то воздействие
	//на окружающие объекты по типу "Источник силы" (в будущем могут быть объекты с разной силой)
	public class PowerObject extends InteractiveMapObject
	{
		protected var _range:int;					//Радиус области воздействия
		protected var _reloadTime:int;				//Пауза между воздействиями
		protected var _powerQuantity:int;			//Количество силы, которое воздействует за раз
		
		public function PowerObject() { } 
		
		//По вызову action объект будет отхиливать ближайших живих юнитов
		public function usePower():void { }
	}
	
	//Класс интерактивного взрывающегося объекта (Бочка со взрывчаткой)
	public class ExplosiveObject extends InteractiveMapObject
	{
		protected var _damage:int;					//Количество урона от взрыва
		protected var _range:int;					//Радиус области взрыва
		
		public function ExplosiveObject() { }
		
		//После уничтожения бочки вызывается action
		override public function death():void {
			blow();
			remove();
		}
		
		public function blow():void {
			//Объект взрывается, нанося урон _weaponDamage вокруг себя
			//по области с радиусом _range
		}
	}
	
	//Объект стреляющего статического объекта (здание)
	public class ShootingStaticObject extends InteractiveMapObject
	{
		protected var _reloadTime:int;				//Время перезарядки
		protected var _weaponDamage:int;			//Количество урона от оружия
		protected var _range:int;					//Дальность стрельбы оружия
		
		
		public function ShootingStaticObject() { } 
		
		/**
		 * Проверка на возможность стрелять. Метод вызывается каждый кадр
		 * и проверяет есть ли враги в зоне поражения, если есть проверяем
		 * не находится ли объект в режиме перезарядки.
		 * Если все условия удовлетворяют, производим выстрел.
		 * @param	delta - дельта время между кадрами
		 */
		public function tryShoot(delta:int):void {
			//...checkForShoot...
			if ("checkForShoot" == true) {
				shoot();
			}
		}
		
		/**
		 * Производим выстрел
		 * Создается объект пули
		 */
		public function shoot():void { }
	}
	
	//Интерфейс добавляющий объекту способность перемещения по карте
	public interface IDynamicObject
	{
		function moveSpeed():int;					//скорость перемещения
		function moveTo(x:int, y:int);				//перемещение объекта в указанную точку
	}
	
	//Передвигающийся игровой объект (Юнит)
	public class DynamicMapObject extends InteractiveMapObject implements IDynamicObject
	{
		protected var _movementSpeed:int;			//скорость перемещения объекта
		
		
		public function DynamicMapObject() { }
		
		public function moveSpeed():int { return _movementSpeed; }
	
		//Перемещение объекта в указанную точку на карте с скоростью _movementSpeed
		public function moveTo(x:int, y:int):void { }
	}
	
	//Стреляющий и передвигающийся объект (Стреляющий юнит)
	public class ShootingDynamicObject extends ShootingStaticObject implements IDynamicObject
	{
		protected var _movementSpeed:int;			//скорость перемещения объекта
		
		public function ShootingDynamicObject() { }
		
		public function moveSpeed():int { return _movementSpeed; }
		
		//Перемещение объекта в указанную точку на карте с скоростью _movementSpeed
		public function moveTo(x:int, y:int):void { }
	}
	
	
}