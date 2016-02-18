package 
{
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
	//И с ним никаких взаимодействий не происходит
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
		}
		
		//Условная смерть игрового объекта, уничтожение, убирание с карты
		public function death():void { }
		
		//Выполняет какое-либо действие по заданному тригеру
		public function action():void { }
	}
	
	//Класс ресурсов, которые выпадают на карте и доступны для сбора (Доски, Гравий)
	public class ResourceObject extends InteractiveMapObject
	{
		public var _resType:int;					//Тип ресурса, который начисляется при сборе
		public var amount:int;						//количество выпавших ресурсов
		//Параметр  isVulnarable = false;
		
		public function ResourceObject() { }
		
		//При вызове этого метода ресурсный объект собирается с карты и начисляется игроку
		override public function action():void { }
	}
	
	//Класс добывающих объектов, после взаимодействия с которыми
	//выпадают игровые ресурсы (Дерево, Камень)
	public class MiningObject extends InteractiveMapObject
	{		
		public function MiningObject() { }
		
		//После уничтожения дерева вызывается action
		override public function death():void {
			action();
			remove();
		}
		
		override public function action():void {
			//в данном случае создается объект ресурсов "Доски" с заданным количеством
			//и выкладывается на игровое поле
		}
	}
	
	//Класс объекта, который оказывает какое-то воздействие
	//на окружающие объекты по типу "Источник силы"
	public class PowerObject extends InteractiveMapObject
	{
		protected var _range:int;					//Радиус области воздействия
		protected var _reloadTime:int;				//Пауза между воздействиями
		protected var _powerQuantity:int;			//Количество силы, которое воздействует за раз
		
		public function PowerObject() { } 
		
		//По вызову action объект будет отхиливать ближайших живих юнитов
		override public function action():void { }
	}
	
	//Класс интерактивного взрывающегося объекта (Бочка со взрывчаткой)
	public class ExplosiveObject extends InteractiveMapObject
	{
		protected var _damage:int;					//Количество урона от взрыва
		protected var _range:int;					//Радиус области взрыва
		
		public function ExplosiveObject() { }
		
		//После уничтожения бочки вызывается action
		override public function death():void {
			action();
			remove();
		}
		
		override public function action():void {
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
		public function checkForShoot(delta:int):void {
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
	
	//Передвигающийся игровой объект (Юнит)
	public class DynamicMapObject extends InteractiveMapObject
	{
		protected var _movementSpeed:int;			//скорость перемещения объекта
		
		
		public function DynamicMapObject() { } 
		
		//Перемещение объекта в указанную точку на карте
		public function moveTo(x:int, y:int):void { }
	}
	
	//Стреляющий и передвигающийся объект (Стреляющий юнит)
	public class ShootingDynamicObject extends ShootingStaticObject
	{
		protected var _movementSpeed:int;			//скорость перемещения объекта
		
		
		public function ShootingDynamicObject() { }
		
		//Перемещение объекта в указанную точку на карте с скоростью _movementSpeed
		public function moveTo(x:int, y:int):void { }
	}
	
	
}