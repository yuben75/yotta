# Semantic Versioning, BSD, Represent and compare version strings, pip install -e git://github.com/autopulated/python-semanticversion.git#egg=semantic_version
import semantic_version


# Parse and match pure version strings and version specifications
#
# Versions:
#   "v1.2.3"
#   "1.2.3"
#   "v1.2.3b1"
#   ""        (tip)
#
# Version Specifications:
#  "1.2.3"
#  ">1.2.3"
#  "<1.2.3"
#  ">=1.2.3"
#  "<=1.2.3"
#  "*"        (any version)
#  ""         (any version)
#
# For full details see semantic_version documentation
#



class Version(object):
    def __init__(self, version_string, url=None):
        ''' Wrap the semantic_version Version class so that we can represent
            'tip' versions as well as specific versions, and store an optional
            URL that can represent the location from which we can retrieve this
            version.
        '''
        super(Version, self).__init__()
        self.url = url
        version_string = version_string.strip()
        # try stripping off the v from the front of the version if there is
        # one: the npm convention is to tag versions with a prepended v
        if version_string.startswith('v'):
            self.version = semantic_version.Version(version_string[1:], partial=False)
        elif not version_string:
            self.version = 'tip'
        else:
            self.version = semantic_version.Version(version_string, partial=False)
        self.url = url
        
    def __str__(self):
        return self.version

    def __repr__(self):
        return 'Version(%s %s)' % (self.version, self.url)

    def __cmp__(self, other):
        # if the other is an unwrapped version (used within the Spec class)
        if isinstance(other, semantic_version.Version):
            other_is_specific_ver = True
            other_is_unwrapped = True
        elif not isinstance(other, self.__class__):
            return NotImplemented
        else:
            other_is_specific_ver = isinstance(other.version, semantic_version.Version)
            other_is_unwrapped = False

        self_is_specific_ver  = isinstance(self.version, semantic_version.Version)

        if self.version == 'tip' and other_is_specific_ver:
            return 1
        elif (not other_is_unwrapped) and other.version == 'tip' and self_is_specific_ver:
            return -1
        elif self_is_specific_ver and other_is_specific_ver:
            if other_is_unwrapped:
                return semantic_version.Version.__cmp__(self.version, other)
            else:
                return semantic_version.Version.__cmp__(self.version, other.version)
        elif self.version == 'tip' and other.version == 'tip':
            raise Exception('Comparing two "tip" versions is undefined')
        else:
            raise Exception('Unsupported version comparison: "%s" vs. "%s"' % (self.version, other.version))

    def __eq__(self, other):
        return self.__cmp__(other) == 0

    def __hash__(self):
        return hash(self.version)

    def __ne__(self, other):
        return self.__cmp__(other) != 0

    def __lt__(self, other):
        return self.__cmp__(other) < 0

    def __le__(self, other):
        return self.__cmp__(other) <= 0

    def __gt__(self, other):
        return self.__cmp__(other) > 0

    def __ge__(self, other):
        return self.__cmp__(other) >= 0


# subclass to allow empty specification strings (equivalent to '*')
class Spec(semantic_version.Spec):
    def __init__(self, version_spec):
        if not version_spec:
            version_spec = '*'
        super(Spec, self).__init__(version_spec)

