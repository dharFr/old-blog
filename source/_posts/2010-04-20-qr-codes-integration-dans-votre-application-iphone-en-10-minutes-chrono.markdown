--- 
layout: post
title: "QR Codes: intégration dans votre application iPhone en 10 minutes chrono!"
published: true
meta: 
  _edit_last: "2"
categories:
- iPhone
- Objective-C
- QRCode
type: post
status: publish
---

{% img right /assets/dhar/qrcode.png 150 150 'Decode me if you can' 'Sample QR Code' %}

### Pour les plus pressés, ça se passe ici:

[ZBar: How to add a barcode reader to an iPhone app](http://sourceforge.net/apps/mediawiki/zbar/index.php?title=HOWTO:_Add_a_barcode_reader_to_an_iPhone_app)

### Pour les autres, voilà un peu plus de détails:

Les [QR Codes](http://en.wikipedia.org/wiki/QR_Code) sont de plus en plus répandus dans les applications mobiles. Au détour d'un projet iPhone, vous pourriez être amenés, tout comme moi, à devoir décoder ces carrés "magiques".<!--more-->

Si tel est votre cas, sachez que la tâche sera des plus simples grâce à l'excellent projet [ZBar bar code reader](http://zbar.sourceforge.net/). L'intégration du wrapper Objective-C de cette librairie m'a pris en tout en pour tout 10 minutes. De plus, le scan des codes est effectué à la volée (comprenez sans que l'utilisateur ait besoin de presser le bouton de l'appareil photo, dès que le code est dans le cadre). La documentation limpide fournie sur le wiki du projet transformera votre application en un lecteur de codes à rendre jaloux le caissier de l'hyper en bas de chez vous.

La doc est là:[ZBar: How to add a barcode reader to an iPhone app](http://sourceforge.net/apps/mediawiki/zbar/index.php?title=HOWTO:_Add_a_barcode_reader_to_an_iPhone_app). Dépêchez-vous, plus que 9'30...

#### Décoder des codes QR:

- [L'application ZBar sur l'AppStore](http://itunes.apple.com/us/app/zbar-barcode-reader/id344957305?mt=8)
- [ZXing](http://code.google.com/p/zxing/) (prononcer "Zebra_Crossing")

#### Générer des QR Codes en ligne:

- [Générateur de QR Code](http://qrcode.kaywa.com)
- [QR Code Generator](http://zxing.appspot.com/generator/)

