import Public.Syndication;
import Public.Parser;
import Standards;

//! Handle RFC3339 date and time encoding.
//!
//! @note
//!   this class is a simple wrapper around Public.Standards.RFC3339 to make sure it's present.
//!

#if !constant(Public.Standards.RFC3339)
static void create(mixed ... args)
{
throw(Error.Generic("Public.Syndication.ATOM requires Public.Standards.RFC3339\n"));
}
#else
Calendar.Second _t;

//! create a new RFC3339 instance.
//!
//! @param text
//!   an RFC3339 date and time string to parse.
//!
void create(void|string|object text) {
  if (stringp(text))
    parse(text);
  else if(objectp(text))
    _t = text->second();
}

//! parse an RFC3339 date and time string.
//!
//! @param text
//!   an RFC3339 date and time string to parse.
//!   
void parse(string text) {
  _t = Public.Standards.RFC3339.parse_fulldatetime(text);
}

//! render an RFC3339 date and time string.
//!
//! @note
//!   if no time is set using the calendar() method then the current date and time is returned.
//!
string render() {
  if (_t)
    return Public.Standards.RFC3339.make_fulldatetime(_t);
  else 
    return Public.Standards.RFC3339.make_fulldatetime(Calendar.now());
}

//! Get or set the time of the RFC3339 instance.
//!
//! @param __t
//!   a Calendar.Second instance.
//!
//! @returns
//!   a Calendar.Second instance.
//!
Calendar.Second calendar(void|Calendar.Second __t) {
  if (__t)
    _t = __t;
  return _t;
}

#endif
