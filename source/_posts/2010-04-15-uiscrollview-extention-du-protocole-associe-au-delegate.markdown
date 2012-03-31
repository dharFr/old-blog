--- 
layout: post
title: "UIScrollView: Extention du protocole associé au delegate"
published: true
meta: 
  _edit_last: "2"
categories:
- iPhone
- Objective-C
type: post
status: publish
---

{% img right /assets/dhar/ImageViewer1-161x300.png 161 300 'UIScrollView dans un ImageViewer' 'ImageViewer' %}


Après le grand ménage sur le blog, plein d'enthousiasme, j'ai entrepris de rédiger un tutoriel  détaillé  à propos du développement d'un ImageViewer pour iPhone, avec une interface la plus proche possible de l'application <code>Photos</code>. Au cours de l'écriture de ce billet, j'ai constaté 2 choses:

- Tout d'abord, ça fait un billet sacrément long, à l'écriture comme à la lecture.
- Ensuite et surtout, j'ai constaté que l'intérêt était assez limité car l'exercice s'est révélé relativement simple.

En revanche, lors du développement de mon ImageViewer, il y a un aspect qui a attiré mon attention: l'extension d'un protocole. Ce point précis peut présenter une certaine difficulté pour peu qu'on n'y ai jamais été confronté et il m'a été assez difficile de trouver des exemples clair sur le web.
J'ai donc décidé de rédiger un billet plus court, qui détaille la façon de dériver la classe <code>UIScrollView</code> tout en étendant le protocole <code>UIScrollViewDelegate</code> associé.

<!--more-->
Si vous souhaitez, comme moi, reproduire l'interface de l'application <code>Photos</code> de votre iPhone, vous allez sans doute créer un <code>UIScrollView</code> afin de permettre à l'utilisateur de naviguer d'une image à l'autre. Pour ce faire, le projet "[Scrolling](http://developer.apple.com/iphone/library/samplecode/Scrolling/Listings/MyViewController_m.html#//apple_ref/doc/uid/DTS40008023-MyViewController_m-DontLinkElementID_6)" fourni en exemple dans la documentation d’Apple constitue un bon point de départ. La logique du scroll est contenue dans  les méthodes <code>viewDidLoad</code> et <code>layoutScrollImages</code> du fichier <code>MyViewController.m</code> mais il vous faudra l’adapter un peu à votre cas d’utilisation.

En revanche, j'ai constaté que les événements de <code>Touch</code> n'étaient pas transmis par la <code>UIScrollView</code>. Gênant lorsque l'on veut ajouter des interactions en plus du scroll.

Pour capturer ces événements, qui ne sont pas transmis par la <code>UIScrollView</code>, la logique voudrait que l'on créé une classe qui étends la scrollView. 

En surchargeant la méthode qui transmet les événements, on obtient ce qui suit:

{% codeblock lang:objc %}
// TapScrollView.h
@interface TapScrollView : UIScrollView {
}
@end

// TapScrollView.m
#import "TapScrollView.h"

@implementation TapScrollView
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {

	[self.delegate tap];
	[super touchesBegan:touches withEvent:event];
}
@end
{% endcodeblock %}

À ce stade, il faut ajouter la méthode <code>tap</code> au protocole qui défini le <code>delegate</code> de notre <code>TapScrollView</code>. On procède en ajoutant la définition d'un nouveau protocole dans le fichier <code>TapScrollView.h</code>. 

Ce protocole va étendre <code>UIScrollViewDelegate</code> afin que l'on puisse encore recevoir les événements de touch, comme suit:

{% codeblock lang:objc %}
// TapScrollView.h
@protocol TapScrollViewDelegate <UIScrollViewDelegate>

- (void) tap;

@end

@interface TapScrollView : UIScrollView {
}
@end
{% endcodeblock %}

Si on en reste là, la propriété <code>delegate</code> reste celle défini par <code>UIScrollView</code> car nous ne l'avons pas surchargée. On peut donc supposer que celle-ci répond au protocole <code>UIScrollViewDelegate</code>, et non pas <code>TapScrollViewDelegate</code> comme on l'aurai souhaité. Dans ce cas, il suffit de surcharger la propriété <code>delegate</code> dans <code>TapScrollView</code>. 
Voilà le code obtenu:

{% codeblock lang:objc %}
// TapScrollView.h
@protocol TapScrollViewDelegate <UIScrollViewDelegate>

- (void) tap;

@end

@interface TapScrollView : UIScrollView {
	id<TapScrollViewDelegate> delegate;
}
@property (nonatomic, assign) id<TapScrollViewDelegate> delegate;
@end
{% endcodeblock %}

Ok, on approche du but. <code>TapScrollView</code> réponds bien au protocole et la méthode <code>tap</code> sera correctement appelée elle-aussi. En revanche, les méthodes du protocole <code>UIScrollViewDelegate</code> ne sont plus appelés... 
On tourne en rond.
J'ai mis pas mal de temps à trouver la solution. L'astuce consiste à surcharger aussi les accès à la propriété <code>delegate</code>, de façon à transmettre les appels dans les deux sens (<code>UIScrollView</code> vers <code>TapScrollView</code> et vice-versa). 
Voilà le code final:

{% codeblock lang:objc %}
// TapScrollView.m
#import "TapScrollView.h"

@implementation TapScrollView

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	[self.delegate tap];
	[super touchesBegan:touches withEvent:event];
}

- (id<TapScrollViewDelegate>) delegate {
	return (id<TapScrollViewDelegate>)super.delegate;
} 

- (void) setDelegate :(id<TapScrollViewDelegate>) aDelegate {
	super.delegate = aDelegate;
}
@end
{% endcodeblock %}

Vous voilà donc avec une <code>ScrollView</code> qui, en plus de capturer les événements relatifs au scroll, va transmettre les actions de votre choix. Ici, un simple <code>tap</code>, mais le principe reste valable pour des actions plus complexes.

Quelques liens utilies pour finir:

- [Scrolling](http://developer.apple.com/iphone/library/samplecode/Scrolling/Listings/MyViewController_m.html#//apple_ref/doc/uid/DTS40008023-MyViewController_m-DontLinkElementID_6) : un sample project de la documentation Apple
- [UIScrollViewDelegate Protocol Reference](http://developer.apple.com/iphone/library/documentation/UIKit/Reference/UIScrollViewDelegate_Protocol/Reference/UIScrollViewDelegate.html): tout ce que fait le protocole associé aux UIScrollView (et ce qu'il ne fait pas)
- [Protocols](http://developer.apple.com/iphone/library/documentation/Cocoa/Conceptual/ObjectiveC/Articles/ocProtocols.html#//apple_ref/doc/uid/TP30001163-CH15): la documentation iPhone sur les protocoles



