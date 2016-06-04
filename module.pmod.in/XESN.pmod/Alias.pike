import Public.Syndication;
import Public.Parser;
import Standards;

//! An XESN Alias element.

protected string _contents;

//! Construct either a blank Alias element or parse one.
//! 
//! @param node
//!   nothing, or an XML2.Node to parse for an existing Alias element.
//! 
void create(void|XML2.Node node) {
  if (node &&
      (node->get_ns() == XESN.XMLNS) &&
      (node->get_node_name() == "alias")) {
    contents(node->get_text());
  }
}

//! Get or set the contents of the Alias element.
//! 
//! @param __contents
//!   set the contents of the Alias element.
//!
//! @returns
//!   the current contents of the Alias element.
//!
void|string contents(void|string __contents) {
  if (__contents)
    _contents = __contents;
  return _contents;
}

//! Render the Alias into an XML2.Node
//!
//! @param node
//!   an XML2.Node containing the Aliases parent element.
//!
//! @returns
//!   a new XML2.Node containing the Alias.
//!
XML2.Node render(void|XML2.Node node) {
  if (!contents())
    throw(({ "XESN Alias element contains no contents.\n", backtrace() }));

  if (!node) {
    node = XML2.new_node("alias");
    node->add_ns(XESN.XMLNS, "xesn");
  }
  else {
    catch(node->get_root_node()->add_ns(XESN.XMLNS, "xesn"));
    node = node->new_child("xesn", "alias", "");
  }
  node->set_ns(XESN.XMLNS);
  node->set_content(contents());
  return node;
}

//!
int `==(mixed test) {
  if ((object_program(test) == Public.Syndication.XESN.Alias) &&
      contents() == test->contents())
    return 1;
}

//!
int `!=(mixed test) {
  return !`==(test);
}

//!
protected string _sprintf() {
  return sprintf("Public.Syndication.XESN.Alias(/* %O */)", contents());
}
