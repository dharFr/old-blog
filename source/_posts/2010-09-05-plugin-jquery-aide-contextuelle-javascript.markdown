--- 
layout: post
title: Plugin jQuery - Aide contextuelle Javascript
published: true
meta: 
  _edit_last: "2"
categories:
- Javascript
- jQuery
- jQuery plugin
type: post
status: publish
---
Voilà déjà pas mal de temps que je n'ai rien publié ici... Ce qui ne veux pas dire que j'ai rien dans les cartons. C'est plutôt le temps qui manque un peu quand il s'agit de présenter tout ça de façon correcte.

Pour changer un peu des précédent articles dédiés au développement iPhone, je vais aujourd'hui présenter un petit outil Javascript, utilisant le Framework jQuery. Rien de révolutionnaire, c'est simplement un plugin jQuery permettant de dérouler un bandeau HTML au dessous d'un autre. J'ai appelé ce plugin 'helpBox' car ce widget est particulièrement adapté pour afficher une aide contextuelle.

Voici le <strong> [code source](https://gist.github.com/1101480)</strong>.
<!--more-->
Rien de bien compliqué ici si l'on connais déjà la structure d'un plugin jQuery.
On commence par définir quelques paramètres...

{% codeblock lang:javascript %}
var defaults = {
    helpContent:'<p>help content</p>',  // jQuery Selector or plain text HTML.
    contentCls:'help-content',          // CSS Class applied to the help box.
    buttonCls:'help-button',            // CSS Class applied to the help button.
    buttonText:'Help'                   // Help Button text
}
{% endcodeblock %}

Ensuite, le plugin 'helpBox' se contente de recherche le code HTML du contenu de l'aide pour l'ajouter au document avec le bouton associé.

{% codeblock lang:javascript %}
return this.each( function() {

    var o = options

    // Gets help content
    var content = ( $(o.helpContent).size() &gt; 0 ) ? $(o.helpContent).html() : o.helpContent;

    // Appends help box and help button
    $(this).append("&lt;div class='"+o.contentCls+"'>" + content + "&lt;/div>")
        .append("&lt;div class='"+o.buttonCls+"'>&lt;a href='#'>"+o.buttonText+"&lt;/a>&lt;/div>");

    $(this).find('.'+o.contentCls).hide();

    // [...]
})
{% endcodeblock %}

Ensuite, il ajoute deux gestionnaires d’événement au bouton: un 'mouseover' pour ouvrir le dialogue d'aide et un 'click' pour fermer ce dernier.

{% codeblock lang:javascript %}
// Open the box on button mouseover, close it on click
$(this).find('.'+o.buttonCls+' a').mouseover( function() {

    $(this).parent().prev('.'+o.contentCls+':hidden').slideDown();
}).click( function() {

    $(this).parent().prev('.'+o.contentCls+':visible').slideUp();
});
{% endcodeblock %}

Voilà tout. Facile non?

- Le code complet est ici: <strong> [jquery.helpbox.js](https://gist.github.com/1101480) </strong></li>


Quelques ressources utiles pour finir:

- [jQuery Plugin Authoring](http://docs.jquery.com/Plugins/Authoring)
- [Les bases du développement de plugin jQuery](http://www.learningjquery.com/2007/10/a-plugin-development-pattern) sur learningjquery.com

Enjoy!
