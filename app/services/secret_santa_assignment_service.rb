class SecretSantaAssignmentService
  def initialize(secret_santa)
    @secret_santa = secret_santa
  end

  def call
    return false unless can_generate?
    create_assignments
  end

  private

  def can_generate?
    @secret_santa.draft? && @secret_santa.community.members.count >= 3
  end

  def create_assignments
    members = shuffled_members
    assignments = build_assignments(members)
    
    SecretSantaAssignment.insert_all(assignments)
    @secret_santa.update!(status: 'active')
    true
  end

  def shuffled_members
    @secret_santa.community.members.to_a.shuffle
  end

  def build_assignments(members)
    members.map.with_index do |giver, index|
      receiver = members[(index + 1) % members.size]
      assignment_attributes(giver, receiver)
    end
  end

  def assignment_attributes(giver, receiver)
    {
      secret_santa_id: @secret_santa.id,
      giver_id: giver.id,
      receiver_id: receiver.id,
      created_at: Time.current,
      updated_at: Time.current
    }
  end
end