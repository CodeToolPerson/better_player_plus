## Install

1. Add this to your **pubspec.yaml** file:

```yaml
dependencies:
  better_player: ^0.0.83
```

2. Install it

```bash
$ flutter pub get
```

3. Import it

```dart
import 'package:better_player_plus/better_player_plus.dart';
```

4. (Required) Android configuration. 
   You need to change these settings in order to run Better Player on Android:
* Set compileSdkVersion to *31*.
* Set kotlin version to *1.5.31*.
* Enable multidex.
