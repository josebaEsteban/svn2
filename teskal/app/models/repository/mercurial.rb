# Teskal

# Copyright (C) 2007 Teskal
#

# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation; either version 2
# of the License, or (at your option) any later version.
# 


# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
# 
# You should have received a copy of the GNU General Public License



require 'redmine/scm/adapters/mercurial_adapter'

class Repository::Mercurial < Repository
  attr_protected :root_url
  validates_presence_of :url

  def scm_adapter
    Redmine::Scm::Adapters::MercurialAdapter
  end
  
  def self.scm_name
    'Mercurial'
  end
  
  def entries(path=nil, identifier=nil)
    entries=scm.entries(path, identifier)
    if entries
      entries.each do |entry|
        next unless entry.is_file?
        # Search the DB for the entry's last change
        change = changes.find(:first, :conditions => ["path = ?", scm.with_leading_slash(entry.path)], :order => "#{Changeset.table_name}.committed_on DESC")
        if change
          entry.lastrev.identifier = change.changeset.revision
          entry.lastrev.name = change.changeset.revision
          entry.lastrev.author = change.changeset.committer
          entry.lastrev.revision = change.revision
        end
      end
    end
    entries
  end

  def fetch_changesets
    scm_info = scm.info
    if scm_info
      # latest revision found in database
      db_revision = latest_changeset ? latest_changeset.revision : nil
      # latest revision in the repository
      scm_revision = scm_info.lastrev.identifier.to_i
      
      unless changesets.find_by_revision(scm_revision)
        revisions = scm.revisions('', db_revision, nil)
        transaction do
          revisions.reverse_each do |revision|
            changeset = Changeset.create(:repository => self,
                                         :revision => revision.identifier,
                                         :scmid => revision.scmid,
                                         :committer => revision.author, 
                                         :committed_on => revision.time,
                                         :comments => revision.message)
            
            revision.paths.each do |change|
              Change.create(:changeset => changeset,
                            :action => change[:action],
                            :path => change[:path],
                            :from_path => change[:from_path],
                            :from_revision => change[:from_revision])
            end
          end
        end
      end
    end
  end
end
