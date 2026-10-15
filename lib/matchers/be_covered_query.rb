# frozen_string_literal: true

module Mongoid
  module Matchers
    def be_covered_query
      BeCoveredQuery.new
    end

    class BeCoveredQuery
      PLAN_CHILD_KEYS = %w[inputStage inputStages outerStage innerStage queryPlan winningPlan shards].freeze

      def using_index(name)
        using_indexes(name)
      end

      def using_indexes(*names)
        raise ArgumentError, 'index names must be nonempty strings or symbols' unless names.any? && names.all? { |name| (name.is_a?(String) || name.is_a?(Symbol)) && !name.to_s.empty? }

        @expected_indexes = names.map(&:to_s).uniq.sort
        self
      end

      def matches?(actual)
        @stages = []
        @indexes = []
        return false unless actual.respond_to?(:explain)

        explain = actual.explain
        planner = value_for(explain, :queryPlanner)
        winning_plan = value_for(planner, :winningPlan)
        return false unless winning_plan

        collect_plan(winning_plan)
        covered = @stages.include?('IXSCAN') && (@stages & %w[FETCH COLLSCAN]).empty?
        covered && (!@expected_indexes || ((@indexes.uniq - @expected_indexes).empty? && (@expected_indexes - @indexes).empty?))
      end

      def description
        desc = +'be a covered query'
        desc << " using indexes #{@expected_indexes.inspect}" if @expected_indexes
        desc
      end

      def failure_message
        detail = @stages.empty? ? 'no winning plan was found' : "winning plan stages were #{@stages.inspect}"
        detail += " and indexes were #{@indexes.uniq.inspect}" if @expected_indexes && @stages.any?
        "Expected query to #{description}, but #{detail}"
      end

      def failure_message_when_negated
        "Expected query not to #{description}"
      end

      private

      def value_for(hash, key)
        return unless hash.respond_to?(:[])

        hash[key.to_s] || hash[key.to_sym]
      end

      def collect_plan(plan)
        case plan
        when Hash
          stage = value_for(plan, :stage)
          @stages << stage.to_s if stage
          @indexes << value_for(plan, :indexName) if stage.to_s == 'IXSCAN'
          PLAN_CHILD_KEYS.each { |key| collect_plan(value_for(plan, key)) }
        when Array
          plan.each { |value| collect_plan(value) }
        end
      end
    end
  end
end
