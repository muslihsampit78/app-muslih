<?php

namespace App\Filament\Resources\Questions\Tables;

use App\Enums\QuestionStatus;
use Filament\Actions\BulkActionGroup;
use Filament\Actions\DeleteBulkAction;
use Filament\Actions\EditAction;
use Filament\Tables\Columns\TextColumn;
use Filament\Tables\Filters\SelectFilter;
use Filament\Tables\Table;

class QuestionsTable
{
    public static function configure(Table $table): Table
    {
        return $table
            ->columns([
                TextColumn::make('created_at')
                    ->label(__('Date Received'))
                    ->dateTime('d M Y H:i')
                    ->sortable(),
                TextColumn::make('subject')
                    ->label(__('Question Subject'))
                    ->searchable()
                    ->sortable()
                    ->limit(40)
                    ->description(fn ($record): string => $record->name.' ('.$record->email.')'),
                TextColumn::make('topic.name')
                    ->label(__('Topic'))
                    ->badge()
                    ->color('info')
                    ->sortable()
                    ->searchable(),
                TextColumn::make('status')
                    ->label(__('Status'))
                    ->badge()
                    ->formatStateUsing(fn ($state) => $state instanceof QuestionStatus ? $state->label() : QuestionStatus::tryFrom($state)?->label() ?? $state)
                    ->color(fn ($state) => match ($state instanceof QuestionStatus ? $state : QuestionStatus::tryFrom($state)) {
                        QuestionStatus::Answered => 'success',
                        QuestionStatus::Rejected => 'danger',
                        default => 'warning',
                    })
                    ->sortable(),
                TextColumn::make('answers_count')
                    ->label(__('Responses'))
                    ->counts('answers')
                    ->badge()
                    ->color('gray')
                    ->sortable(),
            ])
            ->defaultSort('created_at', 'desc')
            ->filters([
                SelectFilter::make('status')
                    ->label(__('Filter by Status'))
                    ->options(collect(QuestionStatus::cases())->mapWithKeys(fn (QuestionStatus $s) => [$s->value => $s->label()])),
                SelectFilter::make('topic_id')
                    ->label(__('Filter by Topic'))
                    ->relationship('topic', 'name'),
            ])
            ->recordActions([
                EditAction::make()->label(__('Open & Respond')),
            ])
            ->toolbarActions([
                BulkActionGroup::make([
                    DeleteBulkAction::make(),
                ]),
            ]);
    }
}
