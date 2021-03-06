###
  App specific externs.

  There are several ways how to prevent compiler from mangling symbols:
  @see http://stackoverflow.com/questions/11681070/exposing-dynamically-created-functions-on-objects-with-closure-compiler

  Expose annotation is brittle. @see http://goo.gl/rOQP2c. Quoting properties
  everywhere is verbose and brittle too.

  PATTERN: Put all app specific properties which should not be mangled here. It
  does not matter exact className, just property name. It will not be mangled
  across whole app.
###

# Note these classes are for externs and does not have to match real classes.
class appUserStore
  appUserStore::newSong
  appUserStore::publishedSongs
  appUserStore::songs
  appUserStore::user

class appUser
  appUser::email
  appUser::id
  appUser::name
  appUser::providers
  # Facebook
  appUser::auth
  appUser::expiresIn
  appUser::facebook
  appUser::first_name
  appUser::gender
  appUser::last_name
  appUser::link
  appUser::locale
  appUser::timezone
  appUser::token
  appUser::updated_time
  appUser::verified

class appContactFormMessage
  appContactFormMessage::message

class appSongsSong
  appSongsSong::album
  appSongsSong::artist
  appSongsSong::creator
  appSongsSong::id
  appSongsSong::inTrash
  appSongsSong::lyrics
  appSongsSong::name
  appSongsSong::publisher
  appSongsSong::urlAlbum
  appSongsSong::urlArtist
  appSongsSong::urlName
  # For elastic.
  appSongsSong::language
  appSongsSong::lyricsForSearch
  appSongsSong::updatedAt

class facebookApi
  facebookApi::FB
  facebookApi::accessToken
  facebookApi::api
  facebookApi::authResponse
  facebookApi::expiresIn
  facebookApi::fbAsyncInit
  facebookApi::getLoginStatus
  facebookApi::init
  facebookApi::login
  facebookApi::logout
  facebookApi::scope
  facebookApi::status

class passportWithLocalStrategy
  passportWithLocalStrategy::Strategy
  passportWithLocalStrategy::deserializeUser
  passportWithLocalStrategy::initialize
  passportWithLocalStrategy::serializeUser
  passportWithLocalStrategy::session

class serverClientData
  serverClientData::app
  serverClientData::version

class elasticSearch
  elasticSearch::Client
  elasticSearch::_id
  elasticSearch::_source
  elasticSearch::body
  elasticSearch::bool
  elasticSearch::fields
  elasticSearch::filter
  elasticSearch::filtered
  elasticSearch::hits
  elasticSearch::host
  elasticSearch::id
  elasticSearch::index
  elasticSearch::match
  elasticSearch::multi_match
  elasticSearch::must
  elasticSearch::must_not
  elasticSearch::operator
  elasticSearch::order
  elasticSearch::query
  elasticSearch::search
  elasticSearch::should
  elasticSearch::sort
  elasticSearch::term
  elasticSearch::type

class elasticSearchClientError
  elasticSearchClientError::action
  elasticSearchClientError::error
  elasticSearchClientError::reportedAt
  elasticSearchClientError::script
  elasticSearchClientError::trace
  elasticSearchClientError::userAgent

class expressjs
  expressjs::body
  expressjs::createServer
  expressjs::end
  expressjs::extended
  expressjs::headers
  expressjs::json
  expressjs::listen
  expressjs::location
  expressjs::params
  expressjs::query
  expressjs::send
  expressjs::setHeader
  expressjs::static
  expressjs::status
  expressjs::urlencoded
  expressjs::use
  expressjs::writeHead

class expressSession
  expressSession::resave
  expressSession::saveUninitialized
  expressSession::secret

class nodeCld
  nodeCld::detect
  nodeCld::languages
