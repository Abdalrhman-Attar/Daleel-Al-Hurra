import 'dummy_types.dart';

final List<Dealer> dummyDealers = [
  const Dealer(
    name: 'Elite Motors',
    phone: '+962 79 123 4567',
    email: 'contact@elitemotors.jo',
    address: 'Queen Rania St, Amman, Jordan',
    image: 'https://example.com/images/dealer1.jpg',
  ),
  const Dealer(
    name: 'City Auto Sales',
    phone: '+962 79 765 4321',
    email: 'info@cityautos.jo',
    address: 'Mecca Street, Amman, Jordan',
    image: 'https://example.com/images/dealer2.jpg',
  ),
  const Dealer(
    name: 'Auto Galaxy',
    phone: '+962 78 987 6543',
    email: 'sales@autogalaxy.jo',
    address: 'Gardens St, Amman, Jordan',
    image: 'https://example.com/images/dealer3.jpg',
  ),
];

List<Car> dummyCars = [
  Car(
    name: 'Toyota Corolla',
    image:
        'https://images.unsplash.com/photo-1621007947382-bb3c3994e3fb?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1000&q=80',
    images: [
      'https://images.unsplash.com/photo-1621007947382-bb3c3994e3fb?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1000&q=80',
      'https://images.unsplash.com/photo-1555215695-3004980ad54e?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1000&q=80',
      'https://images.unsplash.com/photo-1493238792000-8113da705763?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1000&q=80',
    ],
    colors: ['White', 'Black', 'Silver'],
    brand: Brand(
      name: 'Toyota',
      image:
          'https://logos-world.net/wp-content/uploads/2020/04/Toyota-Logo.png',
    ),
    model: Model(name: 'Corolla'),
    category: 'Sedan',
    paymentMethod: 'Cash',
    description: 'A reliable compact sedan with great fuel economy.',
    price: 19500.0,
    doors: 4,
    seats: 5,
    fuelType: 'Gasoline',
    transmission: 'Automatic',
    year: '2021',
    mileage: '18,000 km',
    dealer: dummyDealers[0],
  ),
  Car(
    name: 'Honda Civic',
    image:
        'https://images.unsplash.com/photo-1606664515524-ed2f786a0bd6?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1000&q=80',
    images: [
      'https://images.unsplash.com/photo-1606664515524-ed2f786a0bd6?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1000&q=80',
      'https://images.unsplash.com/photo-1563720223185-11003d516935?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1000&q=80',
      'https://images.unsplash.com/photo-1502877338535-766e1452684a?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1000&q=80',
    ],
    colors: ['Red', 'Blue', 'Gray'],
    brand: Brand(
      name: 'Honda',
      image:
          'https://logos-world.net/wp-content/uploads/2021/03/Honda-Logo.png',
    ),
    model: Model(name: 'Civic'),
    category: 'Sedan',
    paymentMethod: 'Installment',
    description: 'Sporty handling and modern infotainment.',
    price: 21000.0,
    doors: 4,
    seats: 5,
    fuelType: 'Gasoline',
    transmission: 'Manual',
    year: '2022',
    mileage: '10,500 km',
    dealer: dummyDealers[1],
  ),
  Car(
    name: 'BMW 3 Series',
    image:
        'https://images.unsplash.com/photo-1555215695-3004980ad54e?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1000&q=80',
    images: [
      'https://images.unsplash.com/photo-1555215695-3004980ad54e?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1000&q=80',
      'https://images.unsplash.com/photo-1449824913935-59a10b8d2000?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1000&q=80',
      'https://images.unsplash.com/photo-1580273916550-e323be2ae537?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1000&q=80',
    ],
    colors: ['Black', 'White', 'Blue'],
    brand: Brand(
      name: 'BMW',
      image: 'https://logos-world.net/wp-content/uploads/2020/04/BMW-Logo.png',
    ),
    model: Model(name: '3 Series'),
    category: 'Sedan',
    paymentMethod: 'Lease',
    description: 'Luxury performance sedan with turbocharged engine.',
    price: 35000.0,
    doors: 4,
    seats: 5,
    fuelType: 'Gasoline',
    transmission: 'Automatic',
    year: '2020',
    mileage: '25,000 km',
    dealer: dummyDealers[2],
  ),
  Car(
    name: 'Tesla Model 3',
    image:
        'https://images.unsplash.com/photo-1560958089-b8a1929cea89?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1000&q=80',
    images: [
      'https://images.unsplash.com/photo-1560958089-b8a1929cea89?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1000&q=80',
      'https://images.unsplash.com/photo-1571068316344-75bc76f77890?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1000&q=80',
      'https://images.unsplash.com/photo-1617788138017-80ad40651399?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1000&q=80',
    ],
    colors: ['White', 'Red', 'Midnight Silver'],
    brand: Brand(
      name: 'Tesla',
      image:
          'https://logos-world.net/wp-content/uploads/2021/08/Tesla-Logo.png',
    ),
    model: Model(name: 'Model 3'),
    category: 'Sedan',
    paymentMethod: 'Cash',
    description: 'All-electric sedan with Long Range battery.',
    price: 42000.0,
    doors: 4,
    seats: 5,
    fuelType: 'Electric',
    transmission: 'Automatic',
    year: '2023',
    mileage: '5,000 km',
    dealer: dummyDealers[0],
  ),
  Car(
    name: 'Ford F-150',
    image:
        'https://images.unsplash.com/photo-1494976688153-c2c3981e3705?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1000&q=80',
    images: [
      'https://images.unsplash.com/photo-1494976688153-c2c3981e3705?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1000&q=80',
      'https://images.unsplash.com/photo-1562664396-65c4fb493071?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1000&q=80',
      'https://images.unsplash.com/photo-1583121274602-3e2820c69888?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1000&q=80',
    ],
    colors: ['Blue', 'Black', 'White'],
    brand: Brand(
      name: 'Ford',
      image: 'https://logos-world.net/wp-content/uploads/2021/08/Ford-Logo.png',
    ),
    model: Model(name: 'F-150'),
    category: 'Truck',
    paymentMethod: 'Installment',
    description: 'Full-size pickup with strong towing capacity.',
    price: 30000.0,
    doors: 4,
    seats: 6,
    fuelType: 'Gasoline',
    transmission: 'Automatic',
    year: '2019',
    mileage: '40,000 km',
    dealer: dummyDealers[1],
  ),
  Car(
    name: 'Jeep Wrangler',
    image:
        'https://images.unsplash.com/photo-1469285994282-454ceb49e63c?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1000&q=80',
    images: [
      'https://images.unsplash.com/photo-1469285994282-454ceb49e63c?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1000&q=80',
      'https://images.unsplash.com/photo-1566024287286-457247b4930f?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1000&q=80',
      'https://images.unsplash.com/photo-1558618047-3c8c76ca7d13?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1000&q=80',
    ],
    colors: ['Green', 'Black', 'Orange'],
    brand: Brand(
      name: 'Jeep',
      image: 'https://logos-world.net/wp-content/uploads/2021/08/Jeep-Logo.png',
    ),
    model: Model(name: 'Wrangler'),
    category: 'SUV',
    paymentMethod: 'Cash',
    description: 'Iconic off-road 4×4 with removable top.',
    price: 32000.0,
    doors: 2,
    seats: 4,
    fuelType: 'Gasoline',
    transmission: 'Manual',
    year: '2021',
    mileage: '22,000 km',
    dealer: dummyDealers[2],
  ),
  Car(
    name: 'Mercedes-Benz C-Class',
    image:
        'https://images.unsplash.com/photo-1618843479313-40f8afb4b4d8?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1000&q=80',
    images: [
      'https://images.unsplash.com/photo-1618843479313-40f8afb4b4d8?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1000&q=80',
      'https://images.unsplash.com/photo-1503376780353-7e6692767b70?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1000&q=80',
      'https://images.unsplash.com/photo-1492144534655-ae79c964c9d7?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1000&q=80',
    ],
    colors: ['Silver', 'Black', 'White'],
    brand: Brand(
      name: 'Mercedes-Benz',
      image:
          'https://logos-world.net/wp-content/uploads/2020/05/Mercedes-Benz-Logo.png',
    ),
    model: Model(name: 'C-Class'),
    category: 'Sedan',
    paymentMethod: 'Lease',
    description: 'Premium sedan with cutting-edge tech.',
    price: 38000.0,
    doors: 4,
    seats: 5,
    fuelType: 'Diesel',
    transmission: 'Automatic',
    year: '2022',
    mileage: '12,000 km',
    dealer: dummyDealers[0],
  ),
  Car(
    name: 'Audi A4',
    image:
        'https://images.unsplash.com/photo-1606016829463-8c7b69e6796b?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1000&q=80',
    images: [
      'https://images.unsplash.com/photo-1606016829463-8c7b69e6796b?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1000&q=80',
      'https://images.unsplash.com/photo-1544636331-e26879cd4d9b?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1000&q=80',
      'https://images.unsplash.com/photo-1558617047-d65f4ef305b0?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1000&q=80',
    ],
    colors: ['White', 'Gray', 'Red'],
    brand: Brand(
      name: 'Audi',
      image: 'https://logos-world.net/wp-content/uploads/2021/03/Audi-Logo.png',
    ),
    model: Model(name: 'A4'),
    category: 'Sedan',
    paymentMethod: 'Cash',
    description: 'Sporty luxury compact with Quattro AWD.',
    price: 34000.0,
    doors: 4,
    seats: 5,
    fuelType: 'Gasoline',
    transmission: 'Automatic',
    year: '2020',
    mileage: '30,000 km',
    dealer: dummyDealers[1],
  ),
  Car(
    name: 'Nissan Leaf',
    image:
        'https://images.unsplash.com/photo-1593941707882-a5bac6861d75?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1000&q=80',
    images: [
      'https://images.unsplash.com/photo-1593941707882-a5bac6861d75?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1000&q=80',
      'https://images.unsplash.com/photo-1542362567-b07e54358753?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1000&q=80',
    ],
    colors: ['White', 'Blue', 'Black'],
    brand: Brand(
      name: 'Nissan',
      image:
          'https://logos-world.net/wp-content/uploads/2021/04/Nissan-Logo.png',
    ),
    model: Model(name: 'Leaf'),
    category: 'Hatchback',
    paymentMethod: 'Installment',
    description: 'Affordable electric hatchback.',
    price: 24000.0,
    doors: 4,
    seats: 5,
    fuelType: 'Electric',
    transmission: 'Automatic',
    year: '2022',
    mileage: '8,000 km',
    dealer: dummyDealers[2],
  ),
  Car(
    name: 'Chevrolet Camaro',
    image:
        'https://images.unsplash.com/photo-1552519507-da3b142c6e3d?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1000&q=80',
    images: [
      'https://images.unsplash.com/photo-1552519507-da3b142c6e3d?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1000&q=80',
      'https://images.unsplash.com/photo-1603584173870-7f23fdae1b7a?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1000&q=80',
      'https://images.unsplash.com/photo-1541443131876-44b03de101c5?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1000&q=80',
    ],
    colors: ['Yellow', 'Black', 'Red'],
    brand: Brand(
      name: 'Chevrolet',
      image:
          'https://logos-world.net/wp-content/uploads/2021/04/Chevrolet-Logo.png',
    ),
    model: Model(name: 'Camaro'),
    category: 'Coupe',
    paymentMethod: 'Cash',
    description: 'American muscle car with V8 power.',
    price: 28000.0,
    doors: 2,
    seats: 4,
    fuelType: 'Gasoline',
    transmission: 'Manual',
    year: '2019',
    mileage: '27,000 km',
    dealer: dummyDealers[0],
  ),
];

List<Brand> brands = [
  Brand(
      name: 'Toyota',
      image: 'assets/images/Toyota.png',
      models: [Model(name: 'Camry'), Model(name: 'Corolla')]),
  Brand(
      name: 'Honda',
      image: 'assets/images/Honda.png',
      models: [Model(name: 'Civic'), Model(name: 'Accord')]),
  Brand(
      name: 'Ford',
      image: 'assets/images/Ford.png',
      models: [Model(name: 'Focus'), Model(name: 'Mustang')]),
  Brand(
      name: 'Chevrolet',
      image: 'assets/images/Chevrolet.png',
      models: [Model(name: 'Malibu'), Model(name: 'Impala')]),
  Brand(
      name: 'Nissan',
      image: 'assets/images/Nissan.png',
      models: [Model(name: 'Altima'), Model(name: 'Maxima')]),
  Brand(
      name: 'BMW',
      image: 'assets/images/BMW.png',
      models: [Model(name: '3 Series'), Model(name: '5 Series')]),
  Brand(
      name: 'Mercedes-Benz',
      image: 'assets/images/Mercedes-Benz.png',
      models: [Model(name: 'C-Class'), Model(name: 'E-Class')]),
  Brand(
      name: 'Audi',
      image: 'assets/images/Audi.png',
      models: [Model(name: 'A4'), Model(name: 'A6')]),
  Brand(
      name: 'Volkswagen',
      image: 'assets/images/Volkswagen.png',
      models: [Model(name: 'Golf'), Model(name: 'Passat')]),
  Brand(
      name: 'Hyundai',
      image: 'assets/images/Hyundai.png',
      models: [Model(name: 'Elantra'), Model(name: 'Sonata')]),
  Brand(
      name: 'Kia',
      image: 'assets/images/Kia.png',
      models: [Model(name: 'Optima'), Model(name: 'Sorento')]),
  Brand(
      name: 'Mazda',
      image: 'assets/images/Mazda.jpg',
      models: [Model(name: 'Mazda3'), Model(name: 'Mazda6')]),
  Brand(
      name: 'Subaru',
      image: 'assets/images/Subaru.png',
      models: [Model(name: 'Impreza'), Model(name: 'Legacy')]),
  Brand(
      name: 'Lexus',
      image: 'assets/images/Lexus.png',
      models: [Model(name: 'ES'), Model(name: 'RX')]),
  Brand(
      name: 'Porsche',
      image: 'assets/images/Porsche.png',
      models: [Model(name: '911'), Model(name: 'Cayenne')]),
  Brand(
      name: 'Volvo',
      image: 'assets/images/Volvo.png',
      models: [Model(name: 'S60'), Model(name: 'XC60')]),
  Brand(
      name: 'Jaguar',
      image: 'assets/images/Jaguar.png',
      models: [Model(name: 'XE'), Model(name: 'XF')]),
  Brand(
      name: 'Land Rover',
      image: 'assets/images/Land Rover.png',
      models: [Model(name: 'Range Rover'), Model(name: 'Discovery')]),
  Brand(
      name: 'Tesla',
      image: 'assets/images/Tesla.png',
      models: [Model(name: 'Model S'), Model(name: 'Model 3')]),
];
