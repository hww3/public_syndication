import Public.Syndication;
import Public.Parser;
import Standards;

//! An ATOM.Category

protected string _term;
protected URI _scheme;
protected string _label;

//! Create an ATOM.Category element.
//!
//! @param node
//!   An XML2.Node to parse for category elements.
//!
void create(void|XML2.Node node) {
  if (node &&
      (node->get_ns() == ATOM.XMLNS) &&
      (node->get_node_name() == "term")) {
    _term = node->get_attributes()->term;
    if (node->get_attributes()->scheme)
      _scheme = URI(node->get_attributes()->scheme);
    if (node->get_attributes()->label)
      _label = node->get_attributes()->label;
  }
}

//! Set this Category element's term.
//!
//! @param __term
//!   a string containing the new term.
//! 
//! @returns
//!   the current term.
//!
string term(void|string __term) {
  if (__term)
    _term = __term;
  return _term;
}

//! The Catergory's scheme.
//!
//! @param __scheme
//!   a Standards.URI object representing the scheme.
//!
//! @returns
//!   the current scheme.
//!
void|URI scheme(void|URI __scheme) {
  if (__scheme)
    _scheme = __scheme;
  return _scheme;
}

//! The Category's label.
//!
//! @param __label
//!   a string containing the label.
//!
//! @returns
//!   the current label.
//!
void|string label(void|string __label) {
  if (__label)
    _label = __label;
  return _label;
}

//! Render the Category into an XML2.Node
//!
//! @param node
//!   an XML2.Node containing the Category's parent element.
//!
//! @returns
//!   a new XML2.Node containing the Author.
//!
XML2.Node render(void|XML2.Node node) {
  if (!term())
    throw(({ "Category element contains no term attribute.", backtrace() }));
  if (!node) {
    node = XML2.new_node("category");
    node->add_ns(ATOM.XMLNS, "atom");
  }
  else {
    catch(node->get_root_node()->add_ns(ATOM.XMLNS, "atom"));
    node = node->new_child("atom", "category", "");
  }
  node->set_ns(ATOM.XMLNS);
  node->set_attribute("term", term());
  if (scheme())
    node->set_attribute("scheme", (string)scheme());
  if (label())
    node->set_attribute("label", label());
  return node;
}

//!
int `==(mixed test) {
  if ((object_program(test) == Public.Syndication.ATOM.Category) &&
      term() == test->term())
    return 1;
}

//!
int `!=(mixed test) {
  return !`==(test);
}

//!
protected string _sprintf() {
  return sprintf("Public.Syndication.ATOM.Category(/* %O */)", term());
}
