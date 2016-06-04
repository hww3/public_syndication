import Public.Parser;
import Public.Syndication;
import Standards;

//! An ATOM Feed element.

protected URI _id;
protected .HRText _title;
protected .RFC3339 _updated;
protected array _authors = ({});
protected array _links = ({});
protected array _categories = ({});
protected array _contributors = ({});
protected .Generator _generator;
protected URI _icon;
protected URI _logo;
protected .HRText _rights;
protected .HRText _subtitle;
protected array _entries = ({});

//! Create an ATOM Feed element.
//!
//! @param node
//!   an XML2.Node to parse as a Feed.
//!
void create(void|XML2.Node node) {
  if (node)
  {
   if((node->get_ns() == ATOM.XMLNS) &&
      (node->get_node_name() == "feed")) {
    // We have to presume it's an ATOM feed.
    foreach(node->children(), object n) {
      if (n->get_ns() == ATOM.XMLNS)
	switch(n->get_node_name()) {
	  case "id":
	    _id = URI(n->get_text());
	    break;
	  case "title":
	    _title = .HRText(n);
	    break;
	  case "updated":
	    _updated = .RFC3339(n->get_text());
	    break;
	  case "author":
	    add_author(.Author(n));
	    break;
	  case "link":
	    add_link(.Link(n));
	    break;
	  case "category":
	    add_category(.Category(n));
	    break;
	  case "contributor":
	    add_contributor(.Contributor(n));
	    break;
	  case "generator":
	    _generator = .Generator(n);
	    break;
	  case "icon":
	    _icon = URI(n->get_text());
	    break;
	  case "logo":
	    _logo = URI(n->get_text());
	    break;
	  case "rights":
	    _rights = .HRText(n);
	    break;
	  case "subtitle":
	    _subtitle = .HRText(n);
	    break;
	  case "entry":
	    add_entry(.Entry(n));
	}
    }
  }
  else
    throw(({ sprintf("XML2.Node %O is not an ATOM feed", node), backtrace() }));
  }
}

/* Required elements */

//! Gets and sets the URI for the Feed ID.
//!
//! @param __id
//!   A new URI to set the ID to.
//!
//! @note
//!   this is a required property.
//!
//! @returns
//!   a Standards.URI object.
//!
URI id(void|URI __id) {
  if (__id)
    _id = __id;
  return _id;
}

//! Get or set the Feed's Title.
//!
//! @param __title
//!   a new human readable text object to set.
//!
//! @note
//!   This is a required property.
//!
//! @returns
//!   a human readable text object.
//!
.HRText title(void|.HRText __title) {
  if (__title)
    _title = __title;
  return _title;
}

//! Get or set the time this Feed was updated in RFC3339 format.
//!
//! @param __updated
//!   an RFC3339 object.
//!
//! @note
//!   this is a required property.
//! 
//! @returns
//!   an RFC3339 object.
//! 
.RFC3339 updated(void|.RFC3339 __updated) {
  if (__updated)
    _updated = __updated;
  return _updated;
}

/* Recommended elements */

//! Add an Author element to the Feed.
//!
//! @param a
//!   an ATOM.Author object.
//!
//! @returns
//!   the number of Authors for this Feed.
//!
int add_author(.Author a) {
  if (!((multiset)_authors)[a])
    _authors += ({ a });
  return sizeof(_authors);
}

//! Remove an Author element from the Feed.
//! 
//! @param a
//!   an ATOM.Author object.
//!
//! @returns
//!   the number of Authors for this Feed.
//!
int rm_author(.Author a) {
  _authors -= ({ a });
  return sizeof(_authors);
}

//! Gets all the Authors on this Feed.
//!
//! @returns
//!   an array(ATOM.Author).
//!
//! @note
//!   this is a recommended property.
//! 
array authors() {
  return _authors;
}

//! Add an Link element to the Feed.
//!
//! @param l
//!   an ATOM.Link object.
//!
//! @returns
//!   the number of Links for this Feed.
//!
int add_link(.Link l) {
  _links -= ({ l });
  _links += ({ l });
  return sizeof(_links);
}

//! Remove an Link element from the Feed.
//! 
//! @param a
//!   an ATOM.Link object.
//!
//! @returns
//!   the number of Links for this Feed.
//!
int rm_link(.Link l) {
  _links -= ({ l });
  return sizeof(_links);
}

//! Gets all the Link on this Feed.
//!
//! @returns
//!   an array(ATOM.Link).
//!
//! @note
//!   this is a recommended property.
//! 
array links() {
  return _links;
}

/* Optional elements */

//! Add a Category element to the Feed.
//!
//! @param c
//!   an ATOM.Category object.
//!
//! @returns
//!   the number of categories for this Feed.
//!
int add_category(.Category c) {
  _categories -= ({ c });
  _categories += ({ c });
  return sizeof(_categories);
}

//! Remove a Category element from the Feed.
//!
//! @param c
//!   an ATOM.Category object.
//!
//! @returns
//!   the number of categories for this Feed.
//!
int rm_category(.Category c) {
  _categories -= ({ c });
  return sizeof(_categories);
}

//! Gets all the categories on this Feed.
//!
//! @returns
//!   an array(ATOM.Category).
//!
array categories() {
  return _categories;
}

//! Add a Contributor element to the Feed.
//!
//! @param c
//!   an ATOM.Contributor object.
//!
//! @returns
//!   the number of contributors for this Feed.
//!
int add_contributor(.Contributor c) {
  _contributors -= ({ c });
  _contributors += ({ c });
  return sizeof(_contributors);
}

//! Remove a Contributor element from the Feed.
//!
//! @param c
//!   an ATOM.Contributor object.
//!
//! @returns
//!   the number of contributors for this Feed.
//!
int rm_contributor(.Contributor c) {
  _contributors -= ({ c });
  return sizeof(_contributors);
}

//! Gets all the contributors on this Feed.
//!
//! @returns
//!   an array(ATOM.Contributor).
//!
array contributors() {
  return _contributors;
}

//! Get or set the generator element on the Feed.
//!
//! @param __generator
//!   an ATOM.Generator instance containing the generator.
//!
//! @returns
//!   an ATOM.Generator instance.
//!
.Generator generator(void|.Generator __generator) {
  if (__generator)
    _generator = __generator;
  return _generator;
}

//! Get or set the icon element on the Feed.
//!
//! @param __icon
//!   a Standards.URI instance containing the URI of the icon.
//!
//! @returns
//!   a Standards.URI instance.
//!
void|URI icon(void|URI __icon) {
  if (__icon)
    _icon = __icon;
  return _icon;
}

//! Get or set the logo element on the Feed.
//!
//! @param __logo
//!   a Standards.URI instance containing the URI of the logo.
//!
//! @returns
//!   a Standards.URI instance.
//!
void|URI logo(void|URI __logo) {
  if (__logo)
    _logo = __logo;
  return _logo;
}

//! Get or set a rights element on the Feed.
//! 
//! @param __source
//!   an ATOM.HRText instance.
//!
//! @returns
//!   an ATOM.HRText instance.
//!
void|.HRText rights(void|.HRText __rights) {
  if (__rights)
    _rights = __rights;
  return _rights;
}

//! Get or set a subtitle element on the Feed.
//! 
//! @param __subtitle
//!   an ATOM.HRText instance.
//!
//! @returns
//!   an ATOM.HRText instance.
//!
void|.HRText subtitle(void|.HRText __subtitle) {
  if (__subtitle)
    _subtitle = __subtitle;
  return _subtitle;
}

//! Add a Entry element to the Feed.
//!
//! @param c
//!   an ATOM.Entry object.
//!
//! @returns
//!   the number of entries for this Feed.
//!
int add_entry(.Entry e) {
  _entries -= ({ e });
  _entries += ({ e });
  return sizeof(_entries);
}

//! Remove a Entry element from the Feed.
//!
//! @param c
//!   an ATOM.Entry object.
//!
//! @returns
//!   the number of entries for this Feed.
//!
int rm_entry(.Entry e) {
  _entries -= ({ e });
  return sizeof(_entries);
}

//! Gets all the entries on this Feed.
//!
//! @returns
//!   an array(ATOM.Entry).
//!
void|array entries() {
  return _entries;
}

//! Render the Feed into an XML2.Node
//!
//! @param node
//!   an XML2.Node containing the Feed's parent element.
//!
//! @returns
//!   a new XML2.Node containing the Feed.
//!
//! @note
//!   if @[node] is not present then render() creates a new XML document with the feed element at the root.
//!
XML2.Node render(void|XML2.Node node) {
  if (!id())
    throw(({ "Feed element must contain an ID.\n", backtrace() }));
  if (!title())
    throw(({ "Feed element must contain a title.\n", backtrace() }));
  if (!updated())
    throw(({ "Feed element must contain a updated.\n", backtrace() }));

  if (!node) {
    node = XML2.new_xml("1.0", "feed");
    node->add_ns(ATOM.XMLNS, "atom");
  }
  else {
    catch(node->get_root_node()->add_ns(ATOM.XMLNS, "atom"));
    node = node->new_child("atom", "feed", "");
  }
  node->set_ns(ATOM.XMLNS);
  node->new_child("atom", "id", (string)id())
    ->set_ns(ATOM.XMLNS);
  title()->render(node);
  node->new_child("atom", "updated", updated()->render())
    ->set_ns(ATOM.XMLNS);
  if (!sizeof(authors())) {
    if (sizeof(entries()) != sizeof(Array.flatten(entries()->authors()) - ({ 0 })))
      throw(({ "Feed must contain at least one author\n", backtrace() }));
  }
  else
    foreach(authors(), object a)
      a->render(node);
  if (!sizeof(links()))
    throw(({ "Feed must contain at least one link back to the feed itself.", backtrace() }));
  else
    foreach(links(), object l) 
      l->render(node);
  if (categories() && sizeof(categories()))
    foreach(categories(), object c)
      c->render(node);
  if (contributors() && sizeof(contributors()))
    foreach(contributors(), object c)
      c->render(node);
  // Note that we override whatever the existing generator
  // may have been because calling render() on feed is
  // effectively generating it fresh.
  .Generator()->render(node);
  if (icon()) 
    node->new_child("atom", "icon", (string)icon())
      ->set_ns(ATOM.XMLNS);
  if (logo())
    node->new_child("atom", "logo", (string)logo())
      ->set_ns(ATOM.XMLNS);
  if (rights())
    rights()->render(node);
  if (subtitle())
    subtitle()->render(node);
  if (entries() && sizeof(entries()))
    foreach(entries(), object e)
      e->render(node);
  return node;
}

//!
int `==(mixed test) {
  if ((object_program(test) == Public.Syndication.ATOM.Feed) &&
      id() == test->id())
    return 1;
}

//!
int `!=(mixed test) {
  return !`==(test);
}

//!
protected string _sprintf() {

  return sprintf("Public.Syndication.ATOM.Feed(/* %O, %O */)", (title()?title()->contents():""), (string)id());
}
