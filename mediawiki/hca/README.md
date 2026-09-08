# HCA Mediawiki Login
Sahil wanted to implement this. Let's see how fast I can do it. Sourced from Mediawiki's [Extension docs](https://www.mediawiki.org/wiki/Manual:Developing_extensions) & [HCA docs](https://auth.hackclub.com/docs/)

## How It Work
idk. I might make it a pluggableauth extension.

## How 2 Install
I just made a new directory, `extensions/HCA` in the Mediawiki root path. Make one there. Make sure `docker-compose.yml` has it as an external volume I think.

Wait I might not even need this with [PluggableAuth](https://www.mediawiki.org/wiki/Extension:PluggableAuth) & OIDC
```
wfLoad( 'PluggableAuth' );
wfLoad( 'OpenID Connect' );

$wgPluggableAuth_Config[] = [
	'plugin' => 'OpenIDConnect',
	'data' => [
		'providerUrl' => 'https://hackclub.com/',
		'clientID' => getenv('HCA_CLIENT_ID'),
		'clientSecret' => getenv('HCA_CLIENT_SECRET'),
	]
]
```